local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup()

local add = MiniDeps.add
local now, later = MiniDeps.now, MiniDeps.later

add('catppuccin/nvim')
now(function() vim.cmd('colorscheme catppuccin') end)

add('famiu/feline.nvim')
now(function()
  local ctp_feline = require('catppuccin.groups.integrations.feline')
  ctp_feline.setup()
  require('feline').setup({ components = ctp_feline.get() })
end)

add('ethanholz/nvim-lastplace')
now(function() require('nvim-lastplace').setup() end)

-- later(function() require('mini.cursorword').setup() end)
-- later(function()
--   local hipatterns = require('mini.hipatterns')
--   hipatterns.setup({
--     highlighters = {
--       fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
--       hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
--       todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
--       note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },
--       hex_color = hipatterns.gen_highlighter.hex_color(),
--     },
--   })
-- end)

later(function() require('mini.pairs').setup() end)
later(function() require('mini.surround').setup() end)
later(function() require('mini.align').setup() end)
later(function() require('mini.move').setup({
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
}) end)
-- later(function() require('mini.operators').setup() end)
later(function() require('mini.comment').setup() end)
add('dcampos/nvim-snippy')
add('honza/vim-snippets')
later(function() require('snippy').setup({
  mappings = {
    is = {
      ['<tab>'] = 'expand_or_advance',
      ['<s-tab>'] = 'previous',
    },
  },
}) end)

later(function() require('mini.pick').setup() end)
later(function() require('mini.files').setup({
  mappings = {
    go_in = '<right>',
    go_out = '<left>',
  },
}) end)

later(function() require('mini.extra').setup() end)

add({
  source = 'NeogitOrg/neogit',
  depends = { 'nvim-lua/plenary.nvim' },
})
later(function() require('neogit').setup() end)

add('kevinhwang91/nvim-bqf')
add('briot/ada.nvim')
add('Tetralux/odin.vim')
add('https://git.sr.ht/~sircmpwn/hare.vim')
add('ziglang/zig.vim')
add('dag/vim2hs')
add('bfrg/vim-cpp-modern')
add('tikhomirov/vim-glsl')
add('zah/nim.vim')
add('imsnif/kdl.vim')
add('fedorenchik/fasm.vim')
add('dstein64/vim-startuptime')

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
    ['<tab>'] = ':bn<cr>',
    ['<S-tab>'] = ':bp<cr>',
    ['<leader>'] = {
      x = ':bd<cr>',
      f = {
        t = ':lua MiniFiles.open()<cr>',
        f = ':Pick files<cr>',
        b = ':Pick buffers<cr>',
        l = ':Pick grep_live<cr>',
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
