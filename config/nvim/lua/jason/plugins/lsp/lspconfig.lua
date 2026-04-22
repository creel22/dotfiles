-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
  return
end

-- -----------------------------------------------------------------------------
-- 1. Global LSP Keymaps (Modern Neovim 0.11+ pattern)
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { noremap = true, silent = true, buffer = ev.buf }

    -- set keybinds
    vim.keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts)
    vim.keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)
    vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
    vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
    vim.keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
    vim.keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
    vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
    vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
    vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
    vim.keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts)
  end,
})

-- -----------------------------------------------------------------------------
-- 2. Diagnostic Appearance
-- -----------------------------------------------------------------------------
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- -----------------------------------------------------------------------------
-- 3. Server Configuration (Native Neovim 0.11+ APIs)
-- -----------------------------------------------------------------------------
local capabilities = cmp_nvim_lsp.default_capabilities()

-- List of servers to enable with default config
local servers = { "html", "ts_ls", "ansiblels", "cssls", "tailwindcss", "emmet_ls", "yamlls" }

-- Default configuration for all servers
for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {
    capabilities = capabilities,
  })
end

-- Special configuration for Lua
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = {
        checkThirdParty = false,
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
})

-- Special configuration for Emmet (filetypes)
vim.lsp.config("emmet_ls", {
  filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})

-- Enable all servers
vim.lsp.enable(vim.list_extend(servers, { "lua_ls" }))
