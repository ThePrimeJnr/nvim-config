require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
	dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
	require("core.bootstrap").gen_chadrc_template()
	require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"

-- Enable auto-save
vim.cmd([[
augroup autosave
autocmd!
autocmd TextChanged,TextChangedI <buffer> silent! write
augroup END
]])

-- Overwrite <Space>x to make the file executable
vim.api.nvim_set_keymap('n', '<Space>l', ':!chmod +x %<CR>', { noremap = true, silent = true })

-- Set tab width to 4 spaces for C files
vim.cmd[[
  autocmd FileType c setlocal tabstop=4
  autocmd FileType c setlocal shiftwidth=4
  autocmd FileType c setlocal noexpandtab
  ]]

-- Automatically format code with auto-indent and remove trailing spaces when leaving insert mode and before saving for .c files
vim.cmd([[
  autocmd FileType c autocmd InsertLeave <buffer> let b:win_view = winsaveview() | silent execute '%normal! gg=G' | call winrestview(b:win_view) | %s/\s\+$//ge
  autocmd FileType c autocmd BufWritePre <buffer> let b:win_view = winsaveview() | silent execute '%normal! gg=G' | call winrestview(b:win_view) | %s/\s\+$//ge
]])

