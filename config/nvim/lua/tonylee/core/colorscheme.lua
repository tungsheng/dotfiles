local status, _ = pcall(vim.cmd, "colorscheme gruvbox")
if not status then
	print("colorscheme not found")
	return
end
