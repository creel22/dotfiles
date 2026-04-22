vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

require("jason.lazy")
require("jason.core.options")
require("jason.core.keymaps")
require("jason.core.colorscheme")
require("jason.plugins.comment")
require("jason.plugins.nvim-tree")
require("jason.plugins.lualine")
require("jason.plugins.telescope")
require("jason.plugins.nvim-cmp")
require("jason.plugins.lsp.mason")
require("jason.plugins.lsp.lspsaga")
require("jason.plugins.lsp.lspconfig")
require("jason.plugins.formatting")
require("jason.plugins.autopairs")
require("jason.plugins.treesitter")
require("jason.plugins.gitsigns")
