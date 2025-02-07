require("core.options")
require("core.keymaps")

-- diagnostic disable
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "cpp" },
	callback = function()
		vim.diagnostic.disable()
	end,
})

-- copilot
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "solarized",
	-- group = ...,
	callback = function()
		vim.api.nvim_set_hl(0, "CopilotSuggestion", {
			fg = "#555555",
			ctermfg = 8,
			force = true,
		})
	end,
})

-- Prevent LSP from overwriting treesitter color settings
vim.highlight.priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level

-- Appearance of diagnostics
vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		-- Add a custom format function to show error codes
		format = function(diagnostic)
			local code = diagnostic.code and string.format("[%s]", diagnostic.code) or ""
			return string.format("%s %s", code, diagnostic.message)
		end,
	},
	underline = false,
	update_in_insert = true,
	float = {
		source = "always", -- Or "if_many"
	},
	-- Make diagnostic background transparent
	on_ready = function()
		vim.cmd("highlight DiagnosticVirtualText guibg=NONE")
	end,
})

-- autocommands
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Set kitty terminal padding to 0 when in nvim
vim.cmd([[
  augroup kitty_mp
  autocmd!
  au VimLeave * :silent !kitty @ set-spacing padding=default margin=default
  au VimEnter * :silent !kitty @ set-spacing padding=0 margin=0 3 0 3
  augroup END
]])

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	require("plugins.dashboard"),
	require("plugins.colortheme"),
	require("plugins.neotree"),
	require("plugins.telescope"),
	require("plugins.bufferline"),
	require("plugins.lualine"),
	require("plugins.treesitter"),
	require("plugins.lsp"),
	require("plugins.noice"),
	require("plugins.autocompletions"),
	require("plugins.formatting"),
	require("plugins.indent-blankline"),
	require("plugins.misc"),
	require("plugins.autopairs"),
	require("plugins.lazygit"),
	require("plugins.undotree"),
	require("plugins.harpoon"),
	require("plugins.obsidian"),
	require("plugins.leetcode"),
	require("plugins.copilot"),
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
