local status, lualine = pcall(require, "lualine")
if not status then
	return
end

-- configure lualine
lualine.setup({
	options = {
		theme = "catppuccin",
		globalstatus = true, -- beautiful flat statusline across all splits
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
	},
})
