-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(ev)
  bufnr = ev.buf
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('L', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.notify('Formatting buffer with LSP', vim.log.levels.INFO)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- document existing key chains
local wk = require 'which-key'
wk.add {
  { '<leader>c',  group = '[C]ode' },
  { '<leader>c_', hidden = true },
  { '<leader>d',  group = '[D]ocument' },
  { '<leader>d_', hidden = true },
  { '<leader>g',  group = '[G]o To' },
  { '<leader>g_', hidden = true },
  { '<leader>h',  group = '[H]arpoon' },
  { '<leader>h_', hidden = true },
  { '<leader>r',  group = '[R]ename' },
  { '<leader>r_', hidden = true },
  { '<leader>s',  group = '[S]earch' },
  { '<leader>s_', hidden = true },
  { '<leader>w',  group = '[W]orkspace' },
  { '<leader>w_', hidden = true },
}

local clangd_cmd = {
  'clangd',
  -- Allow clangd to query PlatformIO cross-compilers for built-in include paths.
  -- Covers xtensa (ESP32/S2), riscv32 (ESP32-C3/C6/H2), and arm (ESP32-S3 variants).
  -- '--query-driver=' .. vim.env.HOME .. '/.platformio/packages/toolchain-*/bin/*-elf-*',
  '--clang-tidy',
  '--header-insertion=iwyu',
}

-- On NixOS the nixpkgs clangd wrapper resolves system include paths itself,
-- and passing --query-driver disables that logic, so the flag must be left
-- off there. Elsewhere mason installs a bare clangd, so whitelist the nix
-- store wrapper compilers used by compile_commands.json in nix-built
-- projects, plus whatever clang is in PATH.
if os.getenv('NIX_NEOVIM') ~= '1' then
  local query_drivers = { '/nix/store/**/bin/*' }
  local clang_driver = vim.fn.exepath 'clang++'
  if clang_driver == '' then
    clang_driver = vim.fn.exepath 'clang'
  end
  if clang_driver ~= '' then
    table.insert(query_drivers, clang_driver)
  end
  table.insert(clangd_cmd, '--query-driver=' .. table.concat(query_drivers, ','))
end

local servers = {
  tailwindcss = {},
  clangd = {
    cmd = clangd_cmd,
  },
  gopls = {},
  pyright = {},
  -- rust_analyzer = {},
  html = { filetypes = { 'html', 'twig', 'hbs', 'tmpl' } },
  ts_ls = {},
  ruff = {},

  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- NixOS provides LSP servers via home-manager packages, so register them
-- directly. On other systems, mason installs and manages the servers for us.
if os.getenv('NIX_NEOVIM') == '1' then
  for server_name, opts in pairs(servers) do
    -- print server name
    vim.notify('Setting up LSP server: ' .. server_name)

    opts = vim.tbl_deep_extend('force', {
      capabilities = capabilities,
      settings = (servers[server_name] or {}).settings,
      filetypes = (servers[server_name] or {}).filetypes,
    }, opts or {})

    vim.lsp.config(server_name, opts)
    vim.lsp.enable(server_name)
  end
else
  require('mason-lspconfig').setup {
    ensure_installed = vim.tbl_keys(servers),
    automatic_enable = false,
  }

  for server_name, opts in pairs(servers) do
    opts = vim.tbl_deep_extend('force', {
      capabilities = capabilities,
    }, opts)

    vim.lsp.config(server_name, opts)
    vim.lsp.enable(server_name)
  end
end
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = on_attach,
})

vim.api.nvim_create_user_command('LspRestart', function()
  local clients = vim.lsp.get_clients()
  local count = #clients

  local buf_map = {}
  for _, client in ipairs(clients) do
    buf_map[client.id] = vim.lsp.get_buffers_by_client_id(client.id)
    client.stop()
  end

  vim.defer_fn(function()
    local visited = {}
    for _, bufs in pairs(buf_map) do
      for _, buf in ipairs(bufs) do
        if not visited[buf] and vim.api.nvim_buf_is_valid(buf) then
          visited[buf] = true
          vim.api.nvim_buf_call(buf, function()
            vim.cmd 'doautocmd FileType'
          end)
        end
      end
    end
    vim.notify('Restarted ' .. count .. ' LSP client(s)', vim.log.levels.INFO)
  end, 500)
end, { desc = 'Restart all LSP clients across all buffers' })

-- vim: ts=2 sts=2 sw=2 et
