-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- =============================================================================
-- STARTING SET UP
-- =============================================================================

-- Preview in completeopt
vim.opt.completeopt:append("preview")

-- Disable Vi compatibility
vim.opt.compatible = false

-- Blink cursor on error instead of beeping
vim.opt.visualbell = true

-- File type detection, plugins, and indentation are on by default in Neovim,
-- but we set them explicitly for clarity.
vim.cmd("filetype on")
vim.cmd("filetype plugin on")
vim.cmd("filetype indent on")

-- Turn syntax highlighting on
vim.cmd("syntax on")

-- Dark background
vim.opt.background = "dark"

-- Gruvbox highlight search helpers
-- (These call into the gruvbox Vimscript functions — still works via vim.keymap)
vim.keymap.set("n", "[oh", function()
  vim.fn["gruvbox#hls_show"]()
end, { silent = true })
vim.keymap.set("n", "]oh", function()
  vim.fn["gruvbox#hls_hide"]()
end, { silent = true })
vim.keymap.set("n", "coh", function()
  vim.fn["gruvbox#hls_toggle"]()
end, { silent = true })

vim.keymap.set("n", "<leader>*", ':let @/ = ""<CR>:call gruvbox#hls_show()<CR>*')
vim.keymap.set("n", "<leader>/", ':let @/ = ""<CR>:call gruvbox#hls_show()<CR>/')
vim.keymap.set("n", "<leader>?", ':let @/ = ""<CR>:call gruvbox#hls_show()<CR>?')

-- Colorscheme
-- vim.cmd("colorscheme retrobox")
-- vim.cmd("colorscheme gruvbox")
-- vim.cmd("colorscheme apprentice")
-- vim.cmd("colorscheme murphy")
vim.cmd("colorscheme elflord")

-- Line numbers
vim.opt.number = true

-- Highlight the current line and column
vim.opt.cursorline = true
vim.opt.cursorcolumn = true

-- Spell check (buffer-local, English)
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"

-- Use spaces instead of tabs
vim.opt.expandtab = true

-- Indent width
vim.opt.shiftwidth = 4

-- Tab display width
vim.opt.tabstop = 4

-- No backup files
vim.opt.backup = false

-- Keep N lines visible above/below cursor when scrolling
vim.opt.scrolloff = 3

-- Wrap long lines
vim.opt.wrap = true

-- Incremental search highlighting
vim.opt.incsearch = true

-- Case-insensitive search ...
vim.opt.ignorecase = true

-- ... unless the query contains uppercase letters
vim.opt.smartcase = true

-- Show partial command in the last line
vim.opt.showcmd = true

-- Show current mode
vim.opt.showmode = true

-- Highlight matching brackets
vim.opt.showmatch = true

-- Highlight all search matches
vim.opt.hlsearch = true

-- Command history size
vim.opt.history = 1000

-- Enhanced command-line completion
vim.opt.wildmenu = true

-- Bash-style completion behaviour
vim.opt.wildmode = "list:longest"

-- Ignore these extensions in wildmenu
vim.opt.wildignore = "*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx"

-- =============================================================================
-- PLUGINS (via vim-plug — or swap for lazy.nvim below)
-- =============================================================================

-- vim-plug still works in Neovim. Call it the same way:
-- vim.cmd([[
-- call plug#begin()
-- Plug 'morhetz/gruvbox'
-- Plug 'kien/rainbow_parentheses.vim'
-- Plug 'teague1toast1eater/awesome-vim-colorschemes'
-- call plug#end()
-- ]])

-- If you'd prefer lazy.nvim, replace the block above with something like:
--
-- require("lazy").setup({
--   "morhetz/gruvbox",
--   "kien/rainbow_parentheses.vim",
--   "teague1toast1eater/awesome-vim-colorschemes",
-- })

-- =============================================================================
-- MAPPINGS
-- =============================================================================

-- Add a blank line below the current line (cursor stays in place)
vim.keymap.set("n", "<CR>", "o<ESC>")

-- Add a blank line above the current line (cursor stays in place)
vim.keymap.set("n", "<S-CR>", "O<ESC>")

-- Execute current line as a shell command
vim.keymap.set("n", "Q", "!!$SHELL<CR>")

-- Execute current visual selection as shell commands
vim.keymap.set("v", "Q", "!$SHELL<CR>")

-- =============================================================================
-- VIMSCRIPT / AUTOCOMMANDS
-- =============================================================================

-- Enable marker-based folding for Vim/Lua files
-- vim.api.nvim_create_augroup("filetype_vim", { clear = true })
-- vim.api.nvim_create_autocmd("FileType", {
-- group = "filetype_vim",
-- pattern = "vim",
-- callback = function()
-- vim.opt_local.foldmethod = "marker"
-- end,
-- })

-- =============================================================================
-- STATUS LINE
-- =============================================================================

-- Add your statusline config here, e.g.:
-- vim.opt.statusline = "%f %y %m %= %l/%L"
