function tim_tag_notify(title, msg)
   naughty.notify({ text = msg,
                    title = title,
                    fg = "#ffggcc",
                    bg = "#bbggcc",
                    ontop = false,
                    timeout = 1 })
end

function runApp(cmd)
   return function () awful.util.spawn(cmd) end
end

-- Require for building menu
require("tim_menu")

-- Require for expose-like: revelation
require("revelation")

-- Wibox
require("tim_wibox")

--
-- Application shortcuts, defined for key grabbing
--

appKeys = {
   e = runApp("tim_edit"),
   m = runApp("run_alpine"),
   d = runApp("stardict"),
   r = runApp("gksudo emacs"),
   t = runApp("thunar"),
   i = runApp("tim_im"),
   b = runApp("tim_guifilebrowser"),
   n = runApp("nautilus"),
   f = runApp("firefox -no-remote"),
   c = runApp("chromium"),
   o = runApp("libreoffice"),
   a = runApp("gnome-alsamixer"),
   u = runApp("aurora")
}

--
-- These are the factors for "centralizing" a windowe.
-- Change these according to your need.
--
local width_factor = 8 / 9
local height_factor = 8 / 9
local taskbar_height = 25

-- My wibox
wiboxes = wiboxes

--
-- Wibox stuff
--
function wibox_toggle_visible(timwibox)
   local status = timwibox[mouse.screen].visible
   timwibox[mouse.screen].visible = not status
end

--
-- ALSA Stuff
--
local volume_percent = "2%"

function tim_amixer_change_vol(control, percent)
   awful.util.spawn("amixer sset " .. control .. " " .. percent)
end

function tim_amixer_show_vol()
   -- naughty.notify({ text = "Hello world",
   --                  title = "Volume",
   --                  fg = "#ffggcc",
   --                  bg = "#bbggcc",
   --                  ontop = true
   --               })
--   local msg = "naughty.notify({ text = \" echo $(tim_getvol) \", title = \"Volume\", fg = \"ffggcc\", bg = \"#bbggcc\",  ontop = true }) | awesome-client"
  -- awful.util.spawn_with_shell("echo " .. msg)
end

--
-- {{{ Key bindings
--
-- Check of globalkeys is defined

globalkeys = globalkeys or {}

globalkeys = awful.util.table.join(
   globalkeys,
   --
   -- Tags navigation
   --
   -- Previous tag
   -- awful.key({ modkey,           }, "Left",
   -- awful.tag.viewprev       ),
   awful.key({ modkey, "Mod1"   }, "Left",
             awful.tag.viewprev       ),
   -- Next tag
   -- awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
   awful.key({ modkey, "Mod1"   }, "Right",
             awful.tag.viewnext       ),
   -- Quick jump
   awful.key({ modkey,           }, "Escape",
             awful.tag.history.restore),

   -- Next window
   awful.key({ modkey,           }, "k",
              function ()
                 awful.client.focus.byidx( 1)
                 if client.focus then
                    client.focus:raise()
                 end
              end),
   -- Previous window
   awful.key({ modkey,           }, "j",
             function ()
                awful.client.focus.byidx(-1)
                if client.focus then client.focus:raise() end
             end),

   --
   -- Layout manipulation
   --
   awful.key({ modkey, "Control" }, "l",
             function () awful.screen.focus_relative( 1) end),
   awful.key({ modkey, "Control" }, "h",
             function () awful.screen.focus_relative(-1) end),
   -- Swap previous
   awful.key({ modkey, "Shift"   }, "k",
             function () awful.client.swap.byidx(  1)    end),
   -- Swap next
   awful.key({ modkey, "Shift"   }, "j",
             function () awful.client.swap.byidx( -1)    end),
   -- Jump the 'main'
   awful.key({ modkey, }, "$",
             function () awful.tag.viewonly(tags[mouse.screen][1]) end),
   -- Jump to urgent
   awful.key({ modkey,           }, "u",
             awful.client.urgent.jumpto),
   -- Quick jump
   awful.key({ "Mod1",           }, "Tab",
             function ()
                awful.client.focus.history.previous()
                if client.focus then
                   client.focus:raise()
                end
             end),
   -- All clients menu
   awful.key({ modkey,           }, "Tab",
             function ()
                -- If you want to always position the menu
                -- on the same place set coordinates
                awful.menu.menu_keys.down = { "Down", "Alt_L" }
                local cmenu = awful.menu.clients({ width=400 },
                                                 { keygrabber=true })
             end),
   -- Toggle unminimize all
   awful.key({ modkey            }, "n",
             function ()
                local all_clients = client.get(mouse.screen)
                for _, c in ipairs(all_clients) do
                   if c.minimized and c:tags()[mouse.screen] == awful.tag.selected(mouse.screen) then
                      c.minimize = false
                      client.focus = c
                      c:raise()
                      return
                   end
                end
             end),
   -- Toggle wibox visible
   awful.key({ modkey             }, "v",
             function ()
                wibox_toggle_visible(wiboxes['bottom'])
                wibox_toggle_visible(wiboxes['top'])
             end
          ),

   --
   -- Standard commands
   --
   -- awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
   -- Restart awesome
   --awful.key({ modkey, "Control" }, "r", rodentbane.start),
   awful.key({ "Mod1", "Control" }, "r", awesome.restart),
   -- Quit awesome
   awful.key({ modkey, "Shift", "Control" }, "q", awesome.quit),
   -- Master increase
   awful.key({ modkey,           }, "l", 
             function () awful.tag.incmwfact( 0.05)    end),
   -- Master decrease
   awful.key({ modkey,           }, "h",
             function () awful.tag.incmwfact(-0.05)    end),
   -- Master add
   awful.key({ modkey, "Shift"   }, "h",
             function () awful.tag.incnmaster( 1)      end),
   -- Master remove
   awful.key({ modkey, "Shift"   }, "l",
             function () awful.tag.incnmaster(-1)      end),
   -- Slave add
   awful.key({ modkey, "Control" }, "h",
             function () awful.tag.incncol( 1)         end),
   -- Slave remove
   awful.key({ modkey, "Control" }, "l",
             function () awful.tag.incncol(-1)         end),
   -- Next layout
   awful.key({ modkey,           }, "space",
             function () awful.layout.inc(layouts,  1) end),
   -- Previous layout
   awful.key({ modkey, "Shift"   }, "space",
             function () awful.layout.inc(layouts, -1) end),
   -- Do revelation
   awful.key({ modkey, "Control" }, "e", revelation.revelation),
   -- Mouse click
   awful.key({ modkey, "Mod1", "Shift" }, "space",
             function () awful.util.spawn("xte 'mouseclick 3'") end),

   --
   -- System commands
   --
   -- Sleep
   awful.key({ }, "XF86Sleep",
             function () awful.util.spawn("xlock") end),
   -- Hibernate
   awful.key({ modkey, "Mod1", "Control" }, "h",
             function () awful.util.spawn("xterm -e 'sudo hibernate'") end),
   -- Suspend
   awful.key({ modkey, "Mod1", "Control" }, "s",
             function () awful.util.spawn("xterm -e 'sudo hibernate-ram'") end),
   -- Lock screen
   awful.key({ modkey, "Mod1", "Control" }, "l",
             function () awful.util.spawn("xlock") end),
   -- Increase volume
   awful.key({  }, "XF86AudioRaiseVolume",
             function ()
                tim_amixer_change_vol("Master playback", volume_percent .. "+")
                tim_amixer_show_vol()
             end),
   -- Decrease volume
   awful.key({  }, "XF86AudioLowerVolume",
             function ()
                tim_amixer_change_vol("Master playback", volume_percent .. "-")
                tim_amixer_show_vol()
             end),
   -- Toggle mute
   awful.key({  }, "XF86AudioMute",
             function ()
                awful.util.spawn("amixer sset Master toggle")
             end
          ),

   --
   -- Custom programs
   --
   awful.key({ modkey }, "Return",
             function (c)
                keygrabber.run(
                   function (mod, key, event)
                      if string.find(key, "Super") then
                         tim_tag_notify(
                            "Application mode",
                            "Press a key to start an application...")
                      end

                      if event == "release" then
                         return true
                      end

                      if not string.find(key, "Shift") then
                         keygrabber.stop()
                      end

                      if appKeys[key] then
                         appKeys[key]()
                      end
                      return true
                   end
                )
             end),


   -- -- Email client
   -- awful.key({ "Mod1", "Shift", "Control" }, "m" ,
   --           function () awful.util.spawn("/home/cmpitg/bin/run_alpine") end),
   -- -- Stardict
   -- awful.key({ "Mod1", "Shift", "Control" }, "d" ,
   --           function () awful.util.spawn("stardict") end),
   -- -- Stardict
   -- awful.key({ "Mod1", "Shift", "Control" }, "r" ,
   --           function () awful.util.spawn("gksudo emacs") end),
   -- -- Terminal
   -- awful.key({ "Mod1", "Control", "Shift" }, "t",
   --           function () awful.util.spawn(terminal) end),
   -- -- Terminator
   -- awful.key({ "Mod1", "Control", "Shift" }, "Insert",
   --           function () awful.util.spawn("terminator") end),

   -- -- File manager
   -- awful.key({  }, "Help",
   --           function () awful.util.spawn("tim_guifilebrowser") end),
   -- -- Instant Messenger
   -- awful.key({ "Mod1", "Control", "Shift" }, "i",
   --           function () awful.util.spawn("tim_im") end),

   -- GNOME system monitor
   awful.key({ "Mod1", "Control" }, "Pause",
             function() runApp("gnome-system-monitor")() end),
   -- Quick terminal
   awful.key({ modkey }, "\\",
             function() runApp(terminal)() end),
   -- -- File manager
   -- awful.key({ "Mod1", "Control", "Shift" }, "b",
   --           function () awful.util.spawn("tim_guifilebrowser") end),
   -- -- Mozilla Firefox
   -- awful.key({ "Mod1", "Control", "Shift" }, "f",
   --           function () awful.util.spawn("firefox -no-remote") end),
   -- -- Chromium-bin
   -- awful.key({ "Mod1", "Control", "Shift" }, "c",
   --           function () awful.util.spawn("chromium") end),
   -- -- OpenOffice.org
   -- awful.key({ "Mod1", "Control", "Shift" }, "o",
   --           function () awful.util.spawn("libreoffice") end),
   -- -- Editor
   -- awful.key({ "Mod1", "Control", "Shift" }, "e",
   --           function () awful.util.spawn("tim_edit") end),
   -- -- GNOME Alsamixer
   -- awful.key({ "Mod1", "Control", "Shift" }, "a",
   --           function () awful.util.spawn("gnome-alsamixer") end),
   -- -- Downloader
   -- awful.key({ "Mod1", "Control", "Shift" }, "j",
   --           function () awful.util.spawn("jd.sh") end),

   --
   -- Prompt commands
   --
   -- Run program
   awful.key({ modkey },            "r",
             function () mypromptbox[mouse.screen]:run() end),
   -- Run program with gmrun
   awful.key({ "Control" }, "Escape",
              function () awful.util.spawn("gmrun") end),
   -- Eval Run code
   awful.key({ modkey, "Control" }, "x",
             function ()
                awful.prompt.run({ prompt = "Eval Lua: " },
                                 mypromptbox[mouse.screen].widget,
                                 awful.util.eval, nil,
                                 awful.util.getdir("cache") .. "/history_eval")
             end)
)

--
-- Client keybindings for each window
--
-- Centralize a window
function tim_centralize(c)
   local current_geometry = screen[c.screen].geometry
   local new_width = current_geometry.width * width_factor
   local new_height = current_geometry.height * height_factor
   local new_x = (current_geometry.width - new_width) / 2
   local new_y = ((current_geometry.height - taskbar_height) - new_height) / 2
   return { new_width = new_width,
            new_height = new_height,
            new_x = new_x, new_y = new_y }
end
--

--
-- Compute the maximum number of digit we need, limited to 9
--
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end
