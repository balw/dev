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
vim.opt.numberwidth = 4 
vim.opt.signcolumn = "yes"


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

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- If the .configs module is missing, this pcall handles it gracefully
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then return end
      
      configs.setup({
        ensure_installed = { "javascript", "typescript", "tsx", "php", "html", "css", "json", "lua", "vim", "vimdoc" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- 1. Setup Mason
      require("mason").setup()
      require("mason-lspconfig").setup({
        -- RENAME: tsserver is now ts_ls
        ensure_installed = { "ts_ls", "phpactor", "html", "cssls" },
      })

      -- 2. Setup Servers
      local lspconfig = require("lspconfig")
      local servers = { "ts_ls", "phpactor", "html", "cssls" }
      
      for _, server in ipairs(servers) do
        -- This check targets the Neovim 0.11+ "framework" deprecation
        if vim.lsp.config then
          -- The new native way
          vim.lsp.config(server, {})
        else
          -- The legacy way (pre-0.11)
          lspconfig[server].setup({})
        end
      end
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

  -- Fuzzy Finder
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Search Text' })
    end
  },

  -- Auto-close brackets and HTML tags
  { "windwp/nvim-autopairs", config = true },
  { "windwp/nvim-ts-autotag", config = true },

  -- Git integration
  { "lewis6991/gitsigns.nvim", config = true },

  -- Easy commenting (gcc to comment a line)
  { "numToStr/Comment.nvim", config = true },
})

-- LSP Keybindings (Only active when an LSP is attached)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)      -- Go to Definition
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)           -- Show documentation
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts) -- Smart Rename
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts) -- Fix/Refactor
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)     -- Find where used
  end,
})