(require :vis)

(local plug (require :plugins/vis-plug))

(local plugins
  [[:erf/vis-cursors]
   {:alias :qf :url "https://repo.or.cz/vis-quickfix"}
   [:lutobler/vis-commentary]
   [:e-zk/vis-shebang]
   ["https://repo.or.cz/vis-surround"]
   ["https://repo.or.cz/vis-goto-file"]
   {:alias :build :url "https://gitlab.com/muhq/vis-build"}])

(plug.init plugins true)

(set plug.plugins.qf.peek true)
(set vis.ftdetect.filetypes.fasm {:ext ["%.fasm$"]})
(set vis.ftdetect.filetypes.elvish {:ext ["%.elv$"]})

(fn nmap [k b]
  (vis:map vis.modes.NORMAL k b))

(nmap " f" ":find-file<Enter>")
(nmap " vs" ":tvsplit<Enter>")
(nmap " hs" ":thsplit<Enter>")
(nmap " m" ":man<Enter>")
(nmap " cm" ":make ")
(nmap " cn" ":cn<Enter>")
(nmap " cp" ":cp<Enter>")
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
    (vis:command_register :tvsplit
      (fn [argv force win selection range]
        (vis:feedkeys (.. ":!tmux split -h vis " (or (. argv 1) vis.win.file.path) :<Enter>))
        (vis:feedkeys :<vis-redraw>)
        true)
      "Find a file")
    (vis:command_register :thsplit
      (fn [argv force win selection range]
        (vis:feedkeys (.. ":!tmux split vis " (or (. argv 1) vis.win.file.path) :<Enter>))
        (vis:feedkeys :<vis-redraw>)
        true)
      "Find a file")
    (vis:command_register :tig
      (fn [argv force win selection range]
        (vis:feedkeys (.. ":!st tig " (. argv 1) :<Enter>))
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