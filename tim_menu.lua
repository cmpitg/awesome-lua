-- {{{ Menu
-- Create a laucher widget and a main menu

Editor_menu = {
   { "Emacs (root)", "/usr/bin/gksudo emacs" },
   { "Emacs", "/usr/bin/emacs" },
   { "Gvim (root)", "/usr/bin/gksudo gvim" },
   { "Gvim", "/usr/bin/gvim" },
   { "My Editor", "/home/cmpitg/bin/tim_edit" }
}

Entertainment_menu = {
   { "tworld", "/home/cmpitg/bin/tworld" },
   { "Ksokoban", "/usr/bin/ksosoban" }
}

File_menu = {
   { "Nautilus", "/usr/bin/nautilus" },
   { "Krusader", "/usr/bin/krusader" },
   { "Thunar", "/usr/bin/thunar" }
}

Graphics_menu = {
   { "Inkscape", "/usr/bin/inkscape" },
   { "GIMP", "/usr/bin/gimp" }
}

Internet_menu = {
   { "Opera", "/usr/bin/opera" },
   { "Chromium", "/usr/bin/chromium" },
   { "Kopete", "/usr/bin/kopete" },
   { "Firefox", "/usr/bin/firefox -noremote" },
   { "Vuze", "/home/cmpitg/bin/vuze" },
   { "Alpine", "/home/cmpitg/bin/run_alpine" }
}

Multimedia_menu = {
   { "Kdenlive", "/usr/bin/kdenlive" },
   { "Audacious", "/usr/bin/audacious" },
   { "Eye of GNOME", "/usr/bin/eog" }
}

Office_menu = {
   { "GNote", "/usr/bin/gnote" },
   { "Okular", "/usr/bin/okular" },
   { "Scribus", "/usr/bin/scribus" },
   { "LibreOffice", "/usr/bin/libreoffice" }
}

Optical_Disk_menu = {
   { "K3b", "/usr/bin/K3b" }
}

Tool_menu = {
   { "VMWare", "/opt/vmware/bin/vmware" },
   { "Roxterm", "/usr/bin/roxterm" }
}

myawesomemenu = {
   { "Manual", terminal .. " -e man awesome" },
   { "Edit rc.lua",
     editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "Restart", awesome.restart },
   { "Quit", awesome.quit }
}

mymainmenu =
   awful.menu({
                 items = {
                    { "Awesome", myawesomemenu, beautiful.awesome_icon },
                    { "Editor", Editor_menu },
                    { "Entertainment", Entertainment_menu },
                    { "File", File_menu },
                    { "Graphics", Graphics_menu },
                    { "Internet", Internet_menu },
                    { "Multimedia", Multimedia_menu },
                    { "Office", Office_menu },
                    { "Optical Disk", Optical_Disk_menu },
                    { "Tool", Tool_menu },
                    { "Terminal", terminal }
                 }
              })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })

globalkeys = globalkeys or {}

globalkeys = awful.util.table.join(
   globalkeys,
   -- Invoke menu
   awful.key({ modkey,           }, "Menu",
             function () mymainmenu:show(true)        end),
   awful.key({ modkey,           }, "w",
             function () mymainmenu:show(true)        end)
)

-- }}}
