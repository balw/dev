-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        integrations = {
          treesitter = true,
          native_lsp = { enabled = true },
          cmp = true,
        },
      })
      vim.cmd("colorscheme catppuccin")
    end,
  },

  -- Treesitter (syntax highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local ok, tsconfigs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        return
      end
      tsconfigs.setup({
        ensure_installed = {
          "javascript", "typescript", "tsx",
          "php", "html", "css", "json"
        },
        highlight = { enable = true },
      })
    end,
  },

  -- LSP installer
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Ensure servers are installed
      require("mason-lspconfig").setup({
        ensure_installed = { "tsserver", "phpactor", "html", "cssls" },
      })

      local lspconfig = require("lspconfig")  -- still safe for now
      lspconfig.ts_ls.setup({})
      lspconfig.phpactor.setup({})
      lspconfig.html.setup({})
      lspconfig.cssls.setup({})
    end,
  },

  -- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },
})

-- =====================
-- Editor options
-- =====================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true