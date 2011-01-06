--
-- Created by Yang Ha Nguyen <cmpitg@gmail.com>
-- Last modified: Fri, 05 Nov 2010 16:56:15 +0700
--
-- My configuration files are heavily commented.  Feel free to adopt them
-- according to your need.  Mail me if you have any difficulties modifying
-- them, I'm willing to help.
--
-- Don't send me ugly code.  Format it, make it clear and elegant.  I hate
-- ugly and bad code.  I have the beautiful programs.  Programs shape the
-- way you think, thus, make it as elegant as you can.
--

require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("naughty")

-- Load Debian menu entries
-- require("debian.menu")

-- Themes define colours, icons, and wallpapers
beautiful.init(awful.util.getdir("config") .. "/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
-- terminal = "x-terminal-emulator"
-- editor = os.getenv("EDITOR") or "editor"
-- terminal = "roxterm"
-- terminal = "/usr/bin/terminal"
terminal       = "/home/cmpitg/bin/tim_terminal"
editor         = "/home/cmpitg/bin/tim_edit"
editor_cmd     = terminal .. " -e " .. editor

modkey = "Mod4"

require("tim_theme")
require("tim_menu")
require("tim_global_mouse_bindings")
require("tim_client_mouse_bindings")
require("tim_wibox")

-- Rodentbane for mouse controlling from keyboard
-- require("tim_rodentbane")

require("tim_tags_config")
require("tim_key_bindings")
require("tim_custom_functions")

clientkeys = clientkeys or {}
clientkeys = awful.util.table.join(
   -- Fullscreen
   awful.key({ modkey,           }, "f",
             function (c) c.fullscreen = not c.fullscreen  end),
   -- Kill
   awful.key({ modkey            }, "x",
             function (c) c:kill()                         end),
   -- Toggle floating
   awful.key({ modkey, "Control" }, "space",
             awful.client.floating.toggle                     ),
   -- Swap with masters
   awful.key({ modkey,           }, "Return",
             function (c) c:swap(awful.client.getmaster()) end),
   -- Move to screen
   awful.key({ modkey,           }, "o",
             awful.client.movetoscreen                        ),
   -- Redraw client
   awful.key({ modkey, "Shift"   }, "r",
             function (c) c:redraw()                       end),
   -- Toggle minimize
   awful.key({ modkey,           }, "i",
             function (c) c.minimized = not c.minimized    end),
   -- Toggle maximize
   awful.key({ modkey,           }, "m",
             function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c.maximized_vertical   = not c.maximized_vertical
             end),
   -- Bigger
   awful.key({ modkey, }, "End",
             function ()
                awful.client.moveresize(0, 0, 20, 20)
             end),
   -- Smaller
   awful.key({ modkey, }, "Home",
             function ()
                awful.client.moveresize(0, 0, -20, -20)
             end),
   -- Increase transparency
   awful.key({ modkey, "Mod1", "Shift" }, "Down",
             function (c)
                if c.opacity >= 0.10 then
                   c.opacity = c.opacity - 0.10
                end
             end),
   -- Decrease transparency
   awful.key({ modkey, "Mod1", "Shift" }, "Up",
             function (c)
                if c.opacity <= 0.90 then
                   c.opacity = c.opacity + 0.10
                end
             end),
   -- Change transparency to an acceptable number
   awful.key({ modkey, "Mod1", "Shift" }, "Next",
             function (c)
                c.opacity = 0.70
             end),
   -- Restore opacity
   awful.key({ modkey, "Mod1", "Shift" }, "Prior",
             function (c)
                c.opacity = 1
             end),
   -- Minimize all clients
   awful.key({ modkey, }, "d",
             function ()
                local tag = awful.tag.selected()
                for i = 1, #tag:clients() do
                   tag:clients()[i].minimized = not tag:clients()[i].minimized
                   tag:clients()[i]:redraw()
                end
             end
          ),
   -- Centralize the focused client window
   awful.key({ modkey, "Control"          }, "End",
             function (c)
                local tmp = tim_centralize(c)
                c:geometry({ x = tmp.new_x, y = tmp.new_y,
                             width = tmp.new_width, height = tmp.new_height })
                -- awful.client.property.set(c, "geometry", { width=800, height=600 })
             end)

)


--
-- Set keys
--
-- This command is very important
root.keys(globalkeys)
-- }}}

-- require("tim_client_rules")
require("tim_signals")

--awful.util.spawn("/usr/bin/nm-applet --sm-disable &")
awful.util.spawn("/home/cmpitg/bin/tim_xdmautostart")

-- require("tim_autorun")

-- Set desktop background
-- awful.util.spawn("/home/cmpitg/bin/tim_setbg")

-- Testing stuff
-- require("tim_test")
