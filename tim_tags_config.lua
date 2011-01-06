--
-- Custom functions
--

function tim_table_indexOf(table, item)
   table = table or {}
   for i = 1, #table do
      if table[i] == item then
         return i
      end
   end
   return 0
end

function tim_findTag(name)
   return tim_table_indexOf(timTagsInitial, name)
end

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

--
-- Table of layouts to cover with awful.layout.inc, order matters.
--
layouts =
   {
   awful.layout.suit.floating,
   awful.layout.suit.magnifier,
   awful.layout.suit.tile,
   awful.layout.suit.tile.left,
   awful.layout.suit.tile.bottom,
   awful.layout.suit.tile.top,
   awful.layout.suit.fair,
   awful.layout.suit.fair.horizontal,
   awful.layout.suit.spiral,
   awful.layout.suit.spiral.dwindle,
   awful.layout.suit.max,
   awful.layout.suit.max.fullscreen
}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
-- tags = {}
-- for s = 1, screen.count() do
--     -- Each screen has its own tag table.
--     tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
-- end

-- My custom tags
timTagsInitial = { "m", "e", "w", "o", "i", "a", "c", "b", "g", "r", "t" }

tags = {
   -- names = { "main", "www", "office", "im", "back", "coding",
   --        "browser", "graphics", "tmp" },
   names = timTagsInitial,
   layout = {  }
}
for s = 1, screen.count() do
   -- Each screen has its own tag table
   tags[s] = awful.tag(tags.names, s)
end
-- }}}

-- Key bindings
--
-- Bind all key numbers to tags.
--

globalkeys = globalkeys or { }

for i = 1, #timTagsInitial do
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

--
-- Client keys
--

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

-- {{{ Rules
--
-- Client keys are set here
--
awful.rules.rules = {
   -- All clients will match this rule.
   { rule = { },
     properties = { border_width = beautiful.border_width,
                    border_color = beautiful.border_normal,
                    focus = true,
                    keys = clientkeys,
                    buttons = clientbuttons } },
   { rule = { class = "MPlayer" },
     properties = { floating = true } },
   { rule = { class = "VolWheel" },
     properties = { floating = true } },
   { rule = { class = "pinentry" },
     properties = { floating = true } },
   { rule = { class = "Gimp" },
     properties = { floating = true,
                    tag = tags[mouse.screen][tim_findTag("g")] } },
   { rule = { class = "Cinelerra" },
     properties = { floating = true,
                    tag = tags[mouse.screen][tim_findTag("g")] } },
   -- { rule = { class = "Audacity" },
   --   properties = { floating = true,
   --                  tag = tags[mouse.screen][5] } },
   { rule = { class = "Office" },
     properties = { floating = true,
                    tag = tags[mouse.screen][tim_findTag("o")] } },
   { rule = { class = "gmrun" },
     properties = { floating = true } },
   -- Set Firefox to always map on tags number 2 of screen 1.
   { rule = { class = "Firefox" },
     properties = { tag = tags[mouse.screen][tim_findTag("w")] } },
   { rule = { class = "Chromium" },
     properties = { tag = tags[mouse.screen][tim_findTag("w")] } },
   { rule = { class = "Seamonkey" },
     properties = { tag = tags[mouse.screen][tim_findTag("w")] } },
   { rule = { class = "Flock" },
     properties = { tag = tags[mouse.screen][tim_findTag("w")] } },
   { rule = { class = "Pidgin" },
     properties = { tag = tags[mouse.screen][tim_findTag("i")] } },
   { rule = { class = "Empathy" },
     properties = { tag = tags[mouse.screen][tim_findTag("i")] } },
   { rule = { class = "Skype" },
     properties = { tag = tags[mouse.screen][tim_findTag("i")] } },
   { rule = { class = "Kdenlive" },
     properties = { tag = tags[mouse.screen][tim_findTag("g")] } },
   { rule = { class = "Vuze" },
     properties = { tag = tags[mouse.screen][tim_findTag("t")] } },
   { rule = { class = "Nautilus" },
     properties = { tag = tags[mouse.screen][tim_findTag("b")] } },
   { rule = { class = "Krusader" },
     properties = { tag = tags[mouse.screen][tim_findTag("b")] } },
   { rule = { class = "emelFM2" },
     properties = { tag = tags[mouse.screen][tim_findTag("b")] } }
}
-- }}}
