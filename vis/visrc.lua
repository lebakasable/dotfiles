require("vis")
local plug = require("plugins/vis-plug")
local plugins = {{"erf/vis-cursors"}, {alias = "qf", url = "https://repo.or.cz/vis-quickfix"}, {"lutobler/vis-commentary"}, {"e-zk/vis-shebang"}, {"https://repo.or.cz/vis-surround"}, {"https://repo.or.cz/vis-goto-file"}, {alias = "build", url = "https://gitlab.com/muhq/vis-build"}, {"ingolemo/vis-smart-backspace"}}
plug.init(plugins, true)
plug.plugins.qf.peek = true
vis.ftdetect.filetypes.fasm = {ext = {"%.fasm$"}}
vis.ftdetect.filetypes.elvish = {ext = {"%.elv$"}}
vis.ftdetect.filetypes.mochi = {ext = {"%.moc$"}}
vis.ftdetect.filetypes.verilog = {ext = {}}
vis.ftdetect.filetypes.coq = {ext = {"%.v$"}}
vis.ftdetect.filetypes.tofu = {ext = {"%.tofu$"}}
vis.ftdetect.filetypes.tal = {ext = {"%.tal$"}}
vis.ftdetect.filetypes.zig = {ext = {"%.zig$", "%.zig.zon$"}}
vis.ftdetect.filetypes.boba = {ext = {"%.boba$"}}
local function nmap(k, b)
  return vis:map(vis.modes.NORMAL, k, b)
end
nmap(" f", ":find-file<Enter>")
nmap(" m", ":man<Enter>")
nmap(" c", ":cex make ")
nmap(" z", ":cex zig build ")
nmap(" n", ":cn<Enter>")
nmap(" p", ":cp<Enter>")
nmap(" g", ":tig status<Enter>")
nmap(" t", ":term<Enter>")
local function _1_()
  vis:command("set shell bash")
  vis:command("set theme catppuccin-mocha")
  local function _2_(argv, force, win, selection, range)
    vis:feedkeys((":!terminal " .. table.concat(argv, " ") .. " &" .. "<Enter>"))
    vis:feedkeys("<vis-redraw>")
    return true
  end
  vis:command_register("term", _2_)
  local function _3_(argv, force, win, selection, range)
    vis:feedkeys((":!terminal tig " .. argv[1] .. "&" .. "<Enter>"))
    vis:feedkeys("<vis-redraw>")
    return true
  end
  vis:command_register("tig", _3_, "Find a file")
  local function _4_(argv, force, win, selection, range)
    local result = io.popen(string.format("rg --color=never -l '.?' | rofi -dmenu -p \"\239\145\132\""))
    local file = result:read()
    result:close()
    if (type(file) == "string") then
      vis:feedkeys((":e " .. file .. "<Enter>"))
    else
    end
    vis:feedkeys("<vis-redraw>")
    return true
  end
  vis:command_register("find-file", _4_, "Find a file")
  local function _6_(argv, force, win, selection, range)
    local result = io.popen(string.format("man -k . | rofi -dmenu -p \"\239\145\132\""))
    local man = result:read()
    result:close()
    if (type(man) == "string") then
      local page = nil
      for p in man:gmatch("%S+") do
        page = p
        break
      end
      vis:feedkeys((":!man " .. page .. "<Enter>"))
    else
    end
    vis:feedkeys("<vis-redraw>")
    return true
  end
  return vis:command_register("man", _6_, "Find a file")
end
vis.events.subscribe(vis.events.INIT, _1_)
local function _8_(win)
  vis:command("set number")
  vis:command("set relativenumber")
  vis:command("set autoindent")
  vis:command("set expandtab")
  vis:command("set tabwidth 2")
  return vis:command("set showeof off")
end
return vis.events.subscribe(vis.events.WIN_OPEN, _8_)
