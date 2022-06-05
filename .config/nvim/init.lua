require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'ms-jpq/coq_nvim'
  use 'ms-jpq/coq.artifacts'
  use 'norcalli/nvim-colorizer.lua'

  use 'jakewvincent/texmagic.nvim'
  use 'neovim/nvim-lspconfig'
  use 'christoomey/vim-tmux-navigator'
  use 'RyanMillerC/better-vim-tmux-resizer'
  use 'beauwilliams/statusline.lua'
  use 'nvim-lua/plenary.nvim'
  use 'akinsho/flutter-tools.nvim'
  use 'lewis6991/gitsigns.nvim'
  use 'f-person/git-blame.nvim'
  use 'sindrets/diffview.nvim'
  use 'gennaro-tedesco/nvim-commaround'
  use 'folke/which-key.nvim'
  use 'folke/trouble.nvim'
  use 'nvim-lua/lsp_extensions.nvim'
  use 'mhartington/formatter.nvim'

  use {
    'tami5/xbase',
    run = 'make install',
    requires = {"nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim"}
  }

  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  use 'sheerun/vim-polyglot'
  use 'TimUntersberger/neogit'
  use 'nvim-telescope/telescope.nvim'
  use 'gelguy/wilder.nvim'
  use 'numToStr/Comment.nvim'
  use "nanozuki/tabby.nvim"

  use 'kyazdani42/nvim-web-devicons'
  use 'nvim-treesitter/nvim-treesitter'
  use 'onsails/lspkind-nvim'
  use 'kosayoda/nvim-lightbulb'
  use 'delphinus/vim-auto-cursorline'
  use 'tpope/vim-unimpaired'
  use 'morhetz/gruvbox'
  use 'skywind3000/asynctasks.vim'
  use 'skywind3000/asyncrun.vim'
end)

vim.cmd("set termguicolors")
vim.cmd("set number relativenumber")
vim.cmd("set signcolumn=number")
vim.cmd("set splitbelow splitright")

vim.cmd("set ignorecase")
vim.cmd("set smartcase")

vim.cmd("set mouse=a")
vim.cmd([[

set ts=2
set expandtab

let g:tmux_navigator_save_on_switch = 2
let g:tmux_navigator_disable_when_zoomed = 1
let g:tmux_resizer_no_mappings = 1

nnoremap <silent> <M-h> :TmuxResizeLeft<CR>
nnoremap <silent> <M-j> :TmuxResizeDown<CR>
nnoremap <silent> <M-k> :TmuxResizeUp<CR>
nnoremap <silent> <M-l> :TmuxResizeRight<CR>

let g:asyncrun_open = 6

nmap <esc><esc> :noh<cr>

let mapleader = " "

hi NonText guifg=bg

]])

local nvim_lsp = require 'lspconfig'

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = {noremap = true, silent = true}
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

require'lspconfig'.dartls.setup {}
require'lspconfig'.clangd.setup {}
require'lspconfig'.pyright.setup {}
require'lspconfig'.eslint.setup {}
require"lspconfig".tsserver.setup {}
require'lspconfig'.cmake.setup {}
require'lspconfig'.rust_analyzer.setup {}
require'lspconfig'.sourcekit.setup {}
require'lspconfig'.texlab.setup {}
require'lspconfig'.cssls.setup {}

require("flutter-tools").setup()
require('neogit').setup()
require('gitsigns').setup()
require('nvim-treesitter.configs').setup {
  highlight = {enable = true},
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm"
    }
  },
  indent = {enable = false},
  rainbow = {enable = true}
}

vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])

require('lspkind').init({})
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

require('Comment').setup()
require("tabby").setup()
require("trouble").setup()

require'lsp_extensions'.inlay_hints {
  highlight = "Comment",
  prefix = " > ",
  aligned = false,
  only_current_line = false,
  enabled = {"ChainingHint"}
}

local prettier = function()
  return {
    exe = "prettier",
    args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0)},
    stdin = true
  }
end

require('formatter').setup {
  logging = true,
  filetype = {
    json = {prettier},
    css = {prettier},
    html = {prettier},
    javascript = {prettier},
    javascriptreact = {prettier},
    lua = {
      function()
        return {
          exe = "lua-format",
          args = {
            "--no-keep-simple-function-one-line", "--no-break-after-operator",
            "--column-limit=88 ", "--break-after-table-lb", "--tab-width=2",
            "--indent-width=2"
          },
          stdin = true
        }
      end
    },
    dart = {
      function()
        return {exe = "dart", args = {"format"}, stdin = true}
      end
    },
    rust = {
      function()
        return {exe = "rustfmt", args = {"--emit=stdout"}, stdin = true}
      end
    },
    python = {
      function()
        return {exe = "black", args = {'-'}, stdin = true}
      end
    },
    cpp = {
      function()
        return {
          exe = "clang-format",
          args = {"--assume-filename", vim.api.nvim_buf_get_name(0)},
          stdin = true,
          cwd = vim.fn.expand('%:p:h') -- Run clang-format in cwd of the file.
        }
      end
    }
  }
}

local cmp = require 'cmp'
cmp.setup({
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({i = cmp.mapping.abort(), c = cmp.mapping.close()}),
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ['<CR>'] = cmp.mapping.confirm({select = true})
  },
  sources = cmp.config.sources({{name = 'nvim_lsp'}}, {{name = 'buffer'}})
})

local statusline = require('statusline')
statusline.tabline = fals

vim.api.nvim_exec([[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.rs,*.lua,*.dart FormatWrite
augroup END
]], true)

require('texmagic').setup({})

require'colorizer'.setup()

local wk = require("which-key")

wk.register({
  a = {"<cmd>lua require('telescope.builtin').lsp_code_actions()<cr>", ""},
  f = {
    f = {"<cmd>lua require('telescope.builtin').find_files()<cr>", "Files"},
    g = {"<cmd>lua require('telescope.builtin').live_grep()<cr>", "Grep"}
  },
  g = {g = {"<cmd>Neogit<cr>", "Neogit"}}
}, {prefix = "<leader>"})
