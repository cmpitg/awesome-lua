-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "Manual", terminal .. " -e man awesome" },
   { "Edit rc.lua", editor_cmd ..
     " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "Restart", awesome.restart },
   { "Quit", awesome.quit }
}

mymainmenu = awful.menu({ items = {
                             { "awesome", myawesomemenu,
                               beautiful.awesome_icon },
                             -- { "Debian", debian.menu.Debian_menu.Debian },
                             { "Terminal", terminal }
                       }})

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })

globalkeys = awful.util.table.join(
   -- Invoke menu
   awful.key({ modkey,           }, "Menu",
             function () mymainmenu:show(true)        end),
   awful.key({ modkey,           }, "w",
             function () mymainmenu:show(true)        end)
)

-- }}}
