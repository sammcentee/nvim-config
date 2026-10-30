-- Show a custom startup screen with the NVIM wordmark and version
vim.opt.shortmess:append("I")
require("welcome")

-- Enable line numbers
vim.opt.number = true

-- Enable relative line numbers
vim.opt.relativenumber = true

-- Set clipboard and buffer to be the same
vim.opt.clipboard = "unnamedplus"

-- Use full RGB colours in the terminal
vim.opt.termguicolors = true

-- Use the terminal background colour (so Neovim matches VS Code) and keep the existing text colours
vim.cmd("highlight Normal guibg=NONE")

-- Show the current line number in yellow (same yellow as the VS Code cursor)
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FFFF00", bold = true })

-- Muted colours for the relative numbers above (blue) and below (green) the cursor
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#6B8BB5" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#6FA38A" })
