--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/


  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Compatibility shims for Neovim 0.11+ API changes
-- Some plugins call these without required parameters or use deprecated functions

local orig_make_position_params = vim.lsp.util.make_position_params
vim.lsp.util.make_position_params = function(window, offset_encoding)
  if offset_encoding == nil then
    local buf = vim.api.nvim_win_get_buf(window or 0)
    local clients = vim.lsp.get_clients({ bufnr = buf })
    if clients[1] then
      offset_encoding = clients[1].offset_encoding
    end
  end
  return orig_make_position_params(window, offset_encoding)
end

-- Suppress jump_to_location deprecation warning (used by Telescope and other plugins)
local orig_jump_to_location = vim.lsp.util.jump_to_location
vim.lsp.util.jump_to_location = function(location, offset_encoding, reuse_win)
  if offset_encoding == nil then
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if clients[1] then
      offset_encoding = clients[1].offset_encoding
    end
  end
  return orig_jump_to_location(location, offset_encoding, reuse_win)
end

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure plugins ]]
require 'lazy-plugins'

-- [[ Setting options ]]
require 'options'

-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ Configure Telescope ]]
-- (fuzzy finder)
require 'telescope-setup'

-- [[ Configure LSP ]]
-- (Language Server Protocol)
require 'lsp-setup'

-- [[ Configure nvim-cmp ]]
-- (completion)
require 'cmp-setup'

-- [[ PlatformIO / ESP32 integration ]]
require 'custom.platformio'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
