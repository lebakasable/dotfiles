(require :vis)

(local plug (require :plugins/vis-plug))

(local plugins
  [[:erf/vis-cursors]
   {:alias :qf :url "https://repo.or.cz/vis-quickfix"}
   [:lutobler/vis-commentary]
   [:e-zk/vis-shebang]
   ["https://repo.or.cz/vis-surround"]
   ["https://repo.or.cz/vis-goto-file"]
   {:alias :build :url "https://gitlab.com/muhq/vis-build"}
   [:ingolemo/vis-smart-backspace]])

(plug.init plugins true)

(set plug.plugins.qf.peek true)
(set vis.ftdetect.filetypes.fasm {:ext ["%.fasm$"]})
(set vis.ftdetect.filetypes.elvish {:ext ["%.elv$"]})
(set vis.ftdetect.filetypes.mochi {:ext ["%.moc$"]})
(set vis.ftdetect.filetypes.verilog {:ext []})
(set vis.ftdetect.filetypes.coq {:ext ["%.v$"]})
(set vis.ftdetect.filetypes.tofu {:ext ["%.tofu$"]})
(set vis.ftdetect.filetypes.tal {:ext ["%.tal$"]})
(set vis.ftdetect.filetypes.zig {:ext ["%.zig$" "%.zig.zon$"]})
(set vis.ftdetect.filetypes.boba {:ext ["%.bobac$"]})

(fn nmap [k b]
  (vis:map vis.modes.NORMAL k b))

(nmap " f" ":find-file<Enter>")
(nmap " m" ":man<Enter>")
(nmap " c" ":cex make ")
(nmap " z" ":cex zig build ")
(nmap " n" ":cn<Enter>")
(nmap " p" ":cp<Enter>")
(nmap " g" ":tig status<Enter>")
(nmap " t" ":term<Enter>")

(vis.events.subscribe vis.events.INIT
  (fn []
    (vis:command "set shell bash")
    (vis:command "set theme catppuccin-mocha")
    (vis:command_register :term
      (fn [argv force win selection range]
        (vis:feedkeys (.. ":!terminal " (table.concat argv " ") " &" :<Enter>))
        (vis:feedkeys :<vis-redraw>)
        true))
    (vis:command_register :tig
      (fn [argv force win selection range]
        (vis:feedkeys (.. ":!terminal tig " (. argv 1) "&" :<Enter>))
        (vis:feedkeys :<vis-redraw>)
        true)
      "Find a file")
    (vis:command_register :find-file
      (fn [argv force win selection range]
        (let [result (io.popen (string.format "rg --color=never -l '.?' | rofi -dmenu -p \"\"")) file (result:read)]
          (result:close)
          (when (= (type file) :string)
            (vis:feedkeys (.. ":e " file :<Enter>)))
          (vis:feedkeys :<vis-redraw>)
          true))
        "Find a file")
    (vis:command_register :man
      (fn [argv force win selection range]
        (let [result (io.popen (string.format "man -k . | rofi -dmenu -p \"\"")) man (result:read)]
          (result:close)
          (when (= (type man) :string)
            (var page nil)
            (each [p (man:gmatch "%S+")]
              (set page p)
              (lua :break))
            (vis:feedkeys (.. ":!man " page :<Enter>)))
          (vis:feedkeys :<vis-redraw>)
          true))
      "Find a file")))

(vis.events.subscribe vis.events.WIN_OPEN
  (fn [win]
    (vis:command "set number")
    (vis:command "set relativenumber")
    (vis:command "set autoindent")
    (vis:command "set expandtab")
    (vis:command "set tabwidth 2")
    (vis:command "set showeof off")))