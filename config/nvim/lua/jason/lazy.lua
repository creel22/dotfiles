local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- 1. Essentials & Navigation
  "nvim-lua/plenary.nvim",
  "christoomey/vim-tmux-navigator",
  "szw/vim-maximizer",
  "tpope/vim-surround",
  "inkarkat/vim-ReplaceWithRegister",
  "nanotee/zoxide.vim",
  "numToStr/Comment.nvim",

  -- 2. Aesthetics & UI
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  "nvim-tree/nvim-tree.lua",
  "nvim-tree/nvim-web-devicons",
  "nvim-lualine/lualine.nvim",
  { "glepnir/lspsaga.nvim", branch = "main" },
  "onsails/lspkind.nvim",

  -- 3. Fuzzy Finding
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

  -- 4. Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- use master but we'll handle the build manually
    build = ":TSUpdate",
  },
  "windwp/nvim-autopairs",
  "windwp/nvim-ts-autotag",

  -- 5. LSP & Completion
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",

  -- 6. Formatting & Linting (The new way)
  "stevearc/conform.nvim",
  "mfussenegger/nvim-lint",

  -- 7. Git & Extras
  "lewis6991/gitsigns.nvim",
  "Exafunction/codeium.vim",
}, {
  -- Lazy Configuration
  rocks = {
    enabled = false, -- Fixes the Luarocks/Hererocks error
  },
})
