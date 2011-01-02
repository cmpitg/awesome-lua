-- Require for building menu
require("tim_menu")

-- Require for expose-like: revelation
require("revelation")

-- Wibox
require("tim_wibox")

--
-- These are the factors for "centralizing" a windowe.
-- Change these according to your need.
--
local width_factor = 7 / 8
local height_factor = 7 / 8
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

-- {{{ Key bindings
globalkeys = awful.util.table.join(
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
   -- Swap previous
   awful.key({ modkey, "Shift"   }, "k",
             function () awful.client.swap.byidx(  1)    end),
   -- Swap next
   awful.key({ modkey, "Shift"   }, "j",
             function () awful.client.swap.byidx( -1)    end),
   awful.key({ modkey, "Control" }, "k",
             function () awful.screen.focus_relative( 1) end),
   awful.key({ modkey, "Control" }, "j",
             function () awful.screen.focus_relative(-1) end),
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
   -- Lock screen
   awful.key({ "Mod1", "Control"   }, "l",
             function () awful.util.spawn("xlock") end),
   -- Hibernate
   awful.key({ modkey, "Mod1", "Control" }, "h",
             function () awful.util.spawn("terminal -e 'hibernate'") end),
   -- Suspend
   awful.key({ modkey, "Mod1", "Control" }, "s",
             function () awful.util.spawn("terminal -e 'hibernate-ram'") end),
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
   -- Email client
   awful.key({ "Mod1", "Shift", "Control" }, "m" ,
             function () awful.util.spawn("/home/cmpitg/bin/run_alpine") end),
   -- Stardict
   awful.key({ "Mod1", "Shift", "Control" }, "d" ,
             function () awful.util.spawn("stardict") end),
   -- Terminal
   awful.key({ "Mod1", "Control", "Shift" }, "Insert",
             function () awful.util.spawn(terminal) end),
   -- File manager
   awful.key({  }, "Help",
             function () awful.util.spawn("tim_guifilebrowser") end),
   -- GNOME system monitor
   awful.key({ "Mod1", "Control" }, "Pause",
             function () awful.util.spawn("gnome-system-monitor") end),
   -- File manager
   awful.key({ "Mod1", "Control", "Shift" }, "b",
             function () awful.util.spawn("tim_guifilebrowser") end),
   -- Mozilla Firefox
   awful.key({ "Mod1", "Control", "Shift" }, "f",
             function () awful.util.spawn("firefox -no-remote") end),
   -- Chromium-bin
   awful.key({ "Mod1", "Control", "Shift" }, "c",
             function () awful.util.spawn("chromium") end),
   -- OpenOffice.org
   awful.key({ "Mod1", "Control", "Shift" }, "o",
             function () awful.util.spawn("ooffice") end),
   -- Editor
   awful.key({ "Mod1", "Control", "Shift" }, "e",
             function () awful.util.spawn("tim_edit") end),
   -- GNOME Alsamixer
   awful.key({ "Mod1", "Control", "Shift" }, "a",
             function () awful.util.spawn("gnome-alsamixer") end),
   -- Downloader
   awful.key({ "Mod1", "Control", "Shift" }, "j",
             function () awful.util.spawn("jd.sh") end),
   
   --
   -- Prompt commands
   --
   -- Run program
   awful.key({ modkey },            "r",
             function () mypromptbox[mouse.screen]:run() end),
   -- Run program with gmrun
   awful.key({ "Mod1" }, "Escape",
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
-- Compute the maximum number of digit we need, limited to 9
--
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

--
-- Bind all key numbers to tags.
--
-- Switch to tag
function timTagViewOnly(screen, tag)
   return function (c)
             if tags[screen][tag] then
                awful.tag.viewonly(tags[screen][tag])
             end
          end
end
-- Toggle tag view
function timTagViewToggle(screen, tag)
   return function (c)
             if tags[screen][tag] then
                awful.tag.viewtoggle(tags[screen][tag])
             end
          end
end
-- Move client to tag
function timMoveClientToTag(tag)
   return function (c)
             if client.focus and tags[client.focus.screen][tag] then
                awful.client.movetotag(tags[client.focus.screen][tag])
             end
          end
end
-- Toggle tag for a client
function timToggleTag(tag)
   return function (c)
             if client.focus and tags[client.focus.screen][tag] then
                awful.client.toggletag(tags[client.focus.screen][tag])
             end
          end
end
-- Move client to the next tag
-- function timMoveClientNextTag()
--    return function (c)
--              local nextTag = client.focus.tags_table()[1]
--              if nextTag == 9 then
--                 nextTag = 1
--              else
--                 nextTag = nextTag + 1
--              end
--              awful.client.movetotag(tags[mouse.screen][nextTag], c)
--           end
-- end

-- globalkeys = awful.util.table.join(
--    globalkeys,
--    -- Move to next tag
--    awful.key({ "Mod1", "Control", "Shift" }, "Right",
--              timMoveClientNextTag))

timTagsInitial = { "m", "w", "o", "i", "a", "c", "b", "g", "r", "t" }
timTagsNum = 10

for i = 1, timTagsNum do
   globalkeys = awful.util.table.join(
      globalkeys,
      -- Switch to tag
      awful.key({ modkey, "Mod1" }, timTagsInitial[i],
                timTagViewOnly(mouse.screen, i)),
      -- View tag
      awful.key({ modkey, "Shift" }, timTagsInitial[i],
                timTagViewToggle(mouse.screen, i)),
      -- Move to tag
      awful.key({ modkey, "Shift", "Mod1" }, timTagsInitial[i],
                timMoveClientToTag(i)),
      -- Toggle tag-name for the client
      awful.key({ modkey, "Shift", "Control", "Mod1" }, timTagsInitial[i],
                timToggleTag(i))
   )
end

-- for i = 1, keynumber do
--    globalkeys = awful.util.table.join(
--       globalkeys,
--       -- Switch to tag
--       awful.key({ modkey }, "F" .. i,
--                 timTagViewOnly(mouse.screen, i)),
--       -- Toggle tag view
--       awful.key({ modkey, "Control" }, "F" .. i,
--                 timTagViewToggle(mouse.screen, i)),
--       -- Move client to tag
--       awful.key({ modkey, "Shift" }, "F" .. i,
--                 timMoveClientToTag(i)),
--       -- Toggle tag
--       awful.key({ modkey, "Control", "Shift" }, "F" .. i,
--                 timToggleTag(i)))
-- end
