-- #######################
-- PACKAGE MANAGEMENT
-- ########################
local execute = vim.api.nvim_command
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

local needtoinstall = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '.. install_path)
  needtoinstall = true
end

vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]], false)

local use = require('packer').use
require('packer').startup(function()
  use 'wbthomason/packer.nvim'       -- Package manager
  use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}} }
  use 'shadmansaleh/lualine.nvim'
  use  'tpope/vim-commentary'
  use  'monsonjeremy/onedark.nvim'
  use 'neovim/nvim-lspconfig'        -- Collection of configurations for built-in LSP client
  use 'hrsh7th/nvim-cmp'           -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'           -- Autocompletion plugin
  use 'hrsh7th/cmp-buffer'
  use 'ray-x/lsp_signature.nvim'
  use 'wellle/targets.vim'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function() require'nvim-tree'.setup {} end }
end)

local packer = require('packer')

if needtoinstall then
    packer.sync()
end


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Mappings.
  local opts = { noremap=true, silent=true }
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gk', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', ',h', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

  require "lsp_signature".on_attach()
end
-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
--
--
require'cmp'.setup {
  sources = {
    { name = 'nvim_lsp' }
  }
}


-- require'lspconfig'.jedi_language_server.setup{
--     on_attach = on_attach,
--     flags = { debounce_text_changes = 150, },
--     capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
--   }
require'lspconfig'.pylsp.setup{
    on_attach = on_attach,
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),

}





--Incremental live completion
vim.o.inccommand = "nosplit"
--Set highlight on search
vim.o.hlsearch = true
vim.o.incsearch = true
--Make line numbers default
vim.wo.number = true
--Do not save when switching buffers
vim.o.hidden = true
--Enable mouse mode
vim.o.mouse = "a"
--Enable break indent
vim.o.breakindent = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
--Save undo history
vim.cmd[[set undofile]]
--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.relativenumber = true
vim.o.smartcase = true
--Decrease update time
vim.o.updatetime = 750 -- no idea what this does //
vim.o.timeoutlen = 350  -- keypress combo time :)
vim.wo.signcolumn="yes"
vim.o.wrap = false
--Remap escape to leave terminal mode
vim.api.nvim_set_keymap('t', '<Esc>', [[<c-\><c-n>]], {noremap = true})
vim.api.nvim_set_keymap('t', 'kj', [[<c-\><c-n>]], {noremap = true})
vim.api.nvim_set_keymap('t', 'jk', [[<c-\><c-n>]], {noremap = true})
-- just in case i want to use space in the future..
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent=true})
vim.g.mapleader = ","
vim.g.maplocalleader = ","
-- Change preview window location
vim.g.splitbelow = true
-- Highlight on yank
vim.api.nvim_exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false)
-- load laast position on start
vim.api.nvim_exec([[
	autocmd BufReadPost * if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit' | exe "normal! g`\"" | endif
]], false)








vim.o.termguicolors = true
require("onedark").setup({
  colors = {bg = '#14161a'}
})
require('lualine').setup({options = {
	theme = 'onedark',
	component_separators = {left ='',right = ''}, --{'', ''},
    section_separators = '',
}})
vim.cmd[[colorscheme onedark]]


-- Telescope
local actions = require('telescope.actions')
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-t>"] = actions.select_tab
      },
    },
    generic_sorter =  require'telescope.sorters'.get_fzy_sorter,
    file_sorter =  require'telescope.sorters'.get_fzy_sorter,
  }
}
--Add leader shortcuts
vim.api.nvim_set_keymap('n', '<leader>f', [[<cmd>lua require('telescope.builtin').find_files()<cr>]], { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '//', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>]], { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>c', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], { noremap = true, silent = true})


local cmp = require'cmp'
require'cmp'.setup({
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
	  ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' })
    }
  })







-- SAVE and ESC
vim.api.nvim_set_keymap('n', '<C-s>', '<esc>:w<cr><esc>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-s>', '<esc>:w<cr><esc>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', 'jk', '<esc>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', 'kj', '<esc>', { noremap = true, silent = true})
--tabs
vim.api.nvim_set_keymap('n', '<Tab>', 'gt', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<S-Tab>', 'gT', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<F12>', ':set spell!<cr>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<A-1>', ':NvimTreeToggle<cr>', { noremap = true, silent = true})
--Add map to enter paste mode
vim.o.pastetoggle="<F9>"
vim.api.nvim_set_keymap('v', '<C-c>', '"*Y :let @+=@*<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-J>', '6jzz', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-K>', '6kzz', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-l>', '10l', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-h>', '10h', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-H>', '<Left>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-L>', '<Right>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-J>', '<Down>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-K>', '<Up>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('o', 'H', '^', { noremap = true, silent = true})
vim.api.nvim_set_keymap('o', 'L', '$', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'H', '^', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'L', '$', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '""', '""<left>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '\'\'', '\'\'<left>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '\'\'\'', "'''<cr>'''<up><cr>", { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '((', '()<left>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '[[', '[]<left>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', ']]', '[]', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '{{', '{}<left>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-a>', '<Home>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-e>', '<End>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<M-f>', '<C-o>e<right>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<M-b>', '<C-o>b', { noremap = true, silent = true})


vim.o.signcolumn = 'no'

