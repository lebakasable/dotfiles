require('vis')

local plug = require('plugins/vis-plug')

local plugins = {
  {'erf/vis-cursors'},
  { url = 'https://repo.or.cz/vis-quickfix', alias = 'qf' },
  {'lutobler/vis-commentary'},
  {'e-zk/vis-shebang'},
  {'https://repo.or.cz/vis-surround'},
  {'https://repo.or.cz/vis-goto-file'},
  { url = 'https://gitlab.com/muhq/vis-build', alias = 'build' },
  {'ingolemo/vis-smart-backspace'},
}

plug.init(plugins, true)
plug.plugins.qf.peek = true

vis.ftdetect.filetypes.fasm = {ext = {'%.fasm$'}}
vis.ftdetect.filetypes.elvish = {ext = {'%.elv$'}}
vis.ftdetect.filetypes.mochi = {ext = {'%.moc$'}}
vis.ftdetect.filetypes.verilog = {ext = {}}
vis.ftdetect.filetypes.coq = {ext = {'%.v$'}}
vis.ftdetect.filetypes.tofu = {ext = {'%.tofu$'}}
vis.ftdetect.filetypes.tal = {ext = {'%.tal$'}}
vis.ftdetect.filetypes.zig = {ext = {'%.zig$', '%.zig.zon$'}}
vis.ftdetect.filetypes.tofu = {ext = {'%.tofu$'}}
vis.ftdetect.filetypes.mochi = {ext = {'%.moc$'}}
vis.ftdetect.filetypes.soba = {ext = {'%.soba$', 'noodle'}}

vis:map(vis.modes.NORMAL, ' f', ':fzf<Enter>')
vis:map(vis.modes.NORMAL, ' c', ':cex make ')
vis:map(vis.modes.NORMAL, ' z', ':cex zig build ')
vis:map(vis.modes.NORMAL, ' n', ':cn<Enter>')
vis:map(vis.modes.NORMAL, ' p', ':cp<Enter>')
vis:map(vis.modes.NORMAL, ' g', ':git<Enter>')
vis:map(vis.modes.NORMAL, ' t', ':term<Enter>')

vis.events.subscribe(vis.events.INIT, function()
  vis:command('set shell bash')
  vis:command('set theme gruvbox')

  vis:command_register('term', function(argv, force, win, selection, range)
    vis:feedkeys(':!terminal ' .. table.concat(argv, ' ') .. ' &<Enter>')
    vis:feedkeys('<vis-redraw>')
    return true
  end)

  vis:command_register('git', function(argv, force, win, selection, range)
    vis:feedkeys(':!terminal lazygit &<Enter>')
    vis:feedkeys('<vis-redraw>')
    return true
  end)

  vis:command_register('fzf', function(argv, force, win, selection, range)
    local result = io.popen('fzf')
    local file = result:read()
    result:close()
    if (type(file) == 'string') then
      vis:feedkeys(':e ' .. file .. '<Enter>')
    end
    vis:feedkeys('<vis-redraw>')
    return true
  end)

  vis:unmap(vis.modes.NORMAL, '<Up>')
  vis:map(vis.modes.NORMAL, '<Up>', 'gk')
  vis:unmap(vis.modes.NORMAL, '<Down>')
  vis:map(vis.modes.NORMAL, '<Down>', 'gj')
  vis:unmap(vis.modes.VISUAL, '<Up>')
  vis:map(vis.modes.VISUAL, '<Up>', 'gk')
  vis:unmap(vis.modes.VISUAL, '<Down>')
  vis:map(vis.modes.VISUAL, '<Down>', 'gj')
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
  vis:command('set number')
  vis:command('set relativenumber')
  vis:command('set autoindent')
  vis:command('set expandtab')
  vis:command('set tabwidth 2')
  vis:command('set showeof off')
end)
