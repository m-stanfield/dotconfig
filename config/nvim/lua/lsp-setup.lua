-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  require('lsp_signature').on_attach(_, bufnr)
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
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- document existing key chains
local wk = require 'which-key'
wk.add {
  { '<leader>c', group = '[C]ode' },
  { '<leader>c_', hidden = true },
  { '<leader>d', group = '[D]ocument' },
  { '<leader>d_', hidden = true },
  { '<leader>g', group = '[G]o To' },
  { '<leader>g_', hidden = true },
  { '<leader>h', group = '[H]arpoon' },
  { '<leader>h_', hidden = true },
  { '<leader>r', group = '[R]ename' },
  { '<leader>r_', hidden = true },
  { '<leader>s', group = '[S]earch' },
  { '<leader>s_', hidden = true },
  { '<leader>w', group = '[W]orkspace' },
  { '<leader>w_', hidden = true },
}

local servers = {
  tailwindcss = {},
  clangd = {},
  gopls = {},
  pyright = {},
  -- rust_analyzer = {},
  html = { filetypes = { 'html', 'twig', 'hbs', 'tmpl' } },
  -- ruff = {},

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

for server_name, opts in pairs(servers) do
  opts = vim.tbl_deep_extend('force', {
    on_attach = on_attach,
    capabilities = capabilities,
  }, opts or {})
  require('lspconfig')[server_name].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = (servers[server_name] or {}).settings,
    filetypes = (servers[server_name] or {}).filetypes,
  }
end

-- vim: ts=2 sts=2 sw=2 et
