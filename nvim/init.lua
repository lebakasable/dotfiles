local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    'catppuccin/nvim',
    config = function()
      require('catppuccin').setup({
        mini = {
          enabled = true,
        },
      })
      vim.cmd('colorscheme catppuccin')
    end,
  },

  {
    'famiu/feline.nvim',
    config = function()
      local ctp_feline = require('catppuccin.groups.integrations.feline')
      ctp_feline.setup()
      require('feline').setup({ components = ctp_feline.get() })
    end,
  },

  {
    'ethanholz/nvim-lastplace',
    config = function()
      require('nvim-lastplace').setup()
    end,
  },

  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.pairs').setup()
      require('mini.surround').setup()
      require('mini.align').setup()
      require('mini.move').setup({
        mappings = {
          left = '<M-left>',
          right = '<M-right>',
          up = '<M-up>',
          down = '<M-down>',
          line_left = '<M-left>',
          line_right = '<M-right>',
          line_up = '<M-up>',
          line_down = '<M-down>',
        },
      })
      require('mini.comment').setup()
      require('mini.pick').setup()
      require('mini.files').setup({
        mappings = {
          go_in = '<right>',
          go_out = '<left>',
        },
      })
      require('mini.extra').setup()
    end,
  },

  {
    'dcampos/nvim-snippy',
    keys = { { '<tab>', mode = 'i' } },
    dependencies = 'honza/vim-snippets',
    config = function()
      require('snippy').setup({
        mappings = {
          is = {
            ['<tab>'] = 'expand_or_advance',
            ['<s-tab>'] = 'previous',
          },
        },
      })
    end,
  },

  {
    'NeogitOrg/neogit',
    cmd = 'Neogit',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require('neogit').setup()
    end,
  },

  {
    'ThePrimeagen/harpoon',
    dependencies = 'nvim-lua/plenary.nvim',
    lazy = true,
  },

  { 'kevinhwang91/nvim-bqf', ft = 'qf' },
  { 'briot/ada.nvim', ft = 'ada' },
  { 'Tetralux/odin.vim', ft = 'odin' },
  { 'https://git.sr.ht/~sircmpwn/hare.vim', ft = 'hare' },
  { 'ziglang/zig.vim', ft = 'zig' },
  { 'dag/vim2hs', ft = 'haskell' },
  { 'bfrg/vim-cpp-modern', ft = { 'c', 'cpp' } },
  { 'tikhomirov/vim-glsl', ft = 'glsl' },
  { 'zah/nim.vim', ft = 'nim' },
  { 'imsnif/kdl.vim', ft = 'kdl' },
  { 'fedorenchik/fasm.vim', ft = 'asm' },

  {
    'jpe90/export-colorscheme.nvim',
    config = function()
      require('export-colorscheme')
    end,
  },
}, {})

local opt, g = vim.opt, vim.g

opt.exrc = true
opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.wrap = false
opt.cursorline = true
opt.termguicolors = true
opt.undofile = true
opt.undodir = vim.fn.expand('~/.config/nvim/undo')
opt.showmode = false
opt.scrolloff = 5
opt.shell = '/usr/bin/bash'

g.mapleader = ' '
g.c_syntax_for_h = true
g.asmsyntax = 'fasm'
g.loaded_perl_provider = false

keymaps = {
  n = {
    U = '<C-r>',
    ['<esc>'] = ':noh<cr>',
    ['<leader>'] = {
      x = ':bd<cr>',
      f = {
        t = ':lua MiniFiles.open()<cr>',
        f = ':Pick files<cr>',
        b = ':Pick buffers<cr>',
        l = ':Pick grep_live<cr>',
      },
      h = {
        a = ':lua require("harpoon.mark").add_file()<cr>',
        f = ':lua require("harpoon.ui").toggle_quick_menu()<cr>',
        n = ':lua require("harpoon.ui").nav_next()<cr>',
        p = ':lua require("harpoon.ui").nav_prev()<cr>',
      },
      c = ':m<space>',
      q = {
        o = ':copen<cr>',
        n = ':cnext<cr>',
        p = ':cprev<cr>',
      },
      g = ':Neogit<cr>',
    },
  },
  v = {
    ['<leader>'] = {
      y = '"+y',
      p = '"+p',
    },
  },
  t = {
    ['<esc><esc>'] = '<C-\\><C-N>',
  },
}

autocmds = {
  ['*.lasm,*.hasm'] = 'setf nasm',
  ['*.adb,*.ads'] = 'call g:gnat.Set_Project_File ("default.gpr")',
  ['*.odin'] = {
    'let &errorformat="%f(%l:%c) %m"',
    'let &makeprg="odin build ."',
  },
  ['*.hs'] = {
    'compiler cabal',
    'set nofoldenable',
  },
  ['*.pas'] = 'compiler fpc',
  ['*.nim'] = 'let &makeprg="nimble build"',
  ['*.asm'] = {
    'compiler fasm',
    'let &makeprg="make"'
  },
  ['*.ml'] = 'compiler ocaml',
}

vim.cmd('cnoreabbrev s s/g<left><left>')
vim.cmd('cnoreabbrev m make')

function parse_keymap(mode, keymap, last_map)
  for map, to in pairs(keymap) do
    new_map = last_map == nil and map or last_map..map
    if type(to) == 'table' then
      if #to > 0 then
        vim.api.nvim_set_keymap(mode, new_map, to[1], { silent = not to[2] })
      else
        parse_keymap(mode, to, new_map)
      end
    else
      vim.api.nvim_set_keymap(mode, new_map, to, { silent = true })
    end
  end
end

for mode, keymap in pairs(keymaps) do
  if type(mode) == 'table' then
    for _, mode in pairs(mode) do
      parse_keymap(mode, keymap, nil)
    end
  else
    parse_keymap(mode, keymap, nil)
  end
end

for ext, cmd in pairs(autocmds) do
  if type(cmd) == 'table' then
    for _, cmd in pairs(cmd) do
      vim.cmd('autocmd BufNewFile,BufRead '..ext..' '..cmd)
    end
  else
    vim.cmd('autocmd BufNewFile,BufRead '..ext..' '..cmd)
  end
end
