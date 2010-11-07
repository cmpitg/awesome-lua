-- Require for building menu
require("tim_menu")

-- {{{ Key bindings
globalkeys = awful.util.table.join(
   --
   -- Tags navigation
   --
   -- Previous tag
   -- awful.key({ modkey,           }, "Left",
   -- awful.tag.viewprev       ),
   awful.key({ "Mod1", "Shift"   }, "Left",
             awful.tag.viewprev       ),
   -- Next tag
   -- awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
   awful.key({ "Mod1", "Shift"   }, "Right",
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
   
   --
   -- Standard commands
   --
   -- awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
   -- Restart awesome
   awful.key({ modkey, "Control" }, "r", awesome.restart),
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
   
   --
   -- Custom programs
   --
   -- Mutt email client
   awful.key({ "Mod1", "Shift", "Control" }, "m" ,
             function () awful.util.spawn("/home/cmpitg/bin/mutt") end),
   -- Stardict
   awful.key({ "Mod1", "Shift", "Control" }, "d" ,
             function () awful.util.spawn("stardict") end),
   -- Terminal
   awful.key({ "Mod1", "Control", "Shift" }, "Insert",
             function () awful.util.spawn(terminal) end),
   -- File manager
   awful.key({  }, "Help",
             function () awful.util.spawn("nautilus") end),
   -- GNOME system monitor
   awful.key({ "Mod1" }, "Pause",
             function () awful.util.spawn("gnome-system-monitor") end),
   
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
   awful.key({ modkey,           }, "n",
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
   awful.key({ modkey, "Mod1", "Control", "Shift" }, "Down",
             function (c)
                if c.opacity > 0 then
                   c.opacity = c.opacity - 5
                end
             end),
   -- Decrease transparency
   awful.key({ modkey, "Mod1", "Control", "Shift" }, "Up",
             function (c)
                if c.opacity < 100 then
                   c.opacity = c.opacity + 5
                end
             end),
   -- Change transparency to an acceptable number
   awful.key({ modkey, "Mod1", "Shift" }, "Down",
             function (c)
                c.opacity = 0.70
             end),
   -- Restore opacity
   awful.key({ modkey, "Mod1", "Shift" }, "Up",
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
          )
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

timTagsInitial = { "m", "w", "o", "i", "a", "c", "b", "g", "t" }

for i = 1, 9 do
   globalkeys = awful.util.table.join(
      globalkeys,
      -- Switch to tag
      awful.key({ modkey, "Mod1" }, timTagsInitial[i],
                timTagViewOnly(mouse.screen, i)),
      -- View tag
      awful.key({ modkey, "Control", "Mod1" }, timTagsInitial[i],
                timTagViewToggle(mouse.screen, i)),
      -- Move to tag
      awful.key({ modkey, "Shift", "Mod1" }, timTagsInitial[i],
                timMoveClientToTag(i)),
      -- Toggle tag-name for the client
      awful.key({ modkey, "Shift", "Control", "Mod1" }, timTagsInitial[i],
                timToggleTag(i))
   )
end
for i = 1, keynumber do
   globalkeys = awful.util.table.join(
      globalkeys,
      -- Switch to tag
      awful.key({ modkey }, "F" .. i,
                timTagViewOnly(mouse.screen, i)),
      -- Toggle tag view
      awful.key({ modkey, "Control" }, "F" .. i,
                timTagViewToggle(mouse.screen, i)),
      -- Move client to tag
      awful.key({ modkey, "Shift" }, "F" .. i,
                timMoveClientToTag(i)),
      -- Toggle tag
      awful.key({ modkey, "Control", "Shift" }, "F" .. i,
                timToggleTag(i)))
end
