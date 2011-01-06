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
tags = {
   -- names = { "main", "www", "office", "im", "back", "coding",
   --        "browser", "graphics", "tmp" },
   names = { "m", "w", "o", "i", "a", "c",
          "b", "g", "r", "t" },
   layout = {  }
}
for s = 1, screen.count() do
   -- Each screen has its own tag table
   tags[s] = awful.tag(tags.names, s)
end
-- }}}
