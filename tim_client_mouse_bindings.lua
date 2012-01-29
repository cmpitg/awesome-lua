--
-- Mouse binding for clients
--
clientbuttons = awful.util.table.join(
   -- Focus and raise
   awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
   -- Move
   awful.button({ modkey }, 1, awful.mouse.client.move),
   -- awful.button({ "Mod1" }, 1, awful.mouse.client.move),
   -- Resize
--   awful.button({ "Mod1" }, 3, awful.mouse.client.resize),
   awful.button({ modkey }, 3, awful.mouse.client.resize),
   -- Kill
   awful.button({ modkey }, 2, function(c) c:kill() end)
)
