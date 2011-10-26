--require("obvious.volume_alsa")
require("vicious")
require("tim_battery")

-- {{{ Wibox
-- Create a textclock widget
-- mytextclock = awful.widget.textclock({ align = "right" },
--                                      "%a %b %d, %H:%M:%S", 1)
--
mytextclock = awful.widget.textclock({ align = "right" },
                                     "%a %Y/%m/%d, %H:%M:%S", 1)

--
-- Create a systray
--
mysystray = widget({ type = "systray" })

--
-- Declaration
--
wiboxes_num = 1
wiboxes = {}
wibox_bottom = {}
wibox_top = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytasklist = {}
titlebar = {}
buttery_textbox = {}
volume_display = {}
meminfo = {}

--
-- Mouse buttons for taglist
--
function taglist_init_buttons()
   mytaglist.buttons = awful.util.table.join(
      awful.button({ }, 1, awful.tag.viewonly),
      awful.button({ modkey }, 1, awful.client.movetotag),
      awful.button({ }, 3, awful.tag.viewtoggle),
      awful.button({ modkey }, 3, awful.client.toggletag),
      awful.button({ }, 4, awful.tag.viewnext),
      awful.button({ }, 5, awful.tag.viewprev) )
end

--
-- Mouse buttons for tasklist
--
function tasklist_init_buttons()
   mytasklist.buttons = awful.util.table.join(
      awful.button({ }, 1, function (c)
                              if not c:isvisible() then
                                 awful.tag.viewonly(c:tags()[1])
                              end
                              client.focus = c
                              c:raise()
                           end),
      awful.button({ }, 3, function ()
                              if instance then
                                 instance:hide()
                                 instance = nil
                              else
                                 instance = awful.menu.clients({ width=250 })
                              end
                           end),
      awful.button({ }, 4, function ()
                              awful.client.focus.byidx(1)
                              if client.focus then client.focus:raise() end
                           end),
      awful.button({ }, 5, function ()
                              awful.client.focus.byidx(-1)
                              if client.focus then client.focus:raise() end
                           end))
end

function battery_widget_init()
   battery_textbox = widget({ type = "textbox" })
   -- battery_textbox.text = "Hello world"
   bat = tim_battery.battery_closure("BAT1")
   battery_textbox.text = bat()
   battery_timer = timer({ timeout = 10 })
   battery_timer:add_signal("timeout", function () battery_textbox.text = bat() end)
   battery_timer:start()
end

--
-- Memory info
--

-- function update_ram_status()
--    local active, total
--    for line in io.lines('/proc/meminfo') do
--       for key, value in string.gmatch(line, "(%w+):\ +(%d+).+") do
--          if key == "Active" then active = tonumber(value)
--          elseif key == "MemTotal" then total = tonumber(value) end
--       end
--    end
--    return string.format("<span color='green'>%.2f M / %.2f M</span> ",
--                         active / 1024, total / 1024)
-- end

-- function meminfo_init()
--    meminfo = widget({ type = "textbox", align = "right" })
--    awful.hooks.timer.register(7, function() meminfo.text = update_ram_status() end)
-- end

function meminfo_init()
   meminfo = widget({ type = "textbox" })
   require("vicious")
   vicious.register(meminfo, vicious.widgets.mem,
                    "<span color='cyan'>$1% ($2MB / $3MB)</span> ", 7)
end

-- function meminfo_init()
--    -- Initialize widget
--    meminfo = awful.widget.progressbar()
--    -- Progressbar properties
--    meminfo:set_width(25)
--    meminfo:set_height(15)
--    meminfo:set_vertical(true)
--    meminfo:set_background_color("#494B4F")
--    meminfo:set_border_color(nil)
--    meminfo:set_color("#AECF96")
--    meminfo:set_gradient_colors({ "#AECF96", "#88A175", "#FF5656" })
--    -- Register widget
--    vicious.register(meminfo, vicious.widgets.mem, "$1 ", 13)
-- end

function volume_widget_init()
   volume_display = widget({ type = "textbox" })
   require("vicious")
   vicious.register(volume_display, vicious.widgets.volume,
                    "<span color='green'>$1$2</span> ", 0.5, "Master")
end

function promptbox_init(s)
   -- Create a promptbox for each screen
   mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
end

function layoutbox_init(s)
   --
   -- Create an imagebox widget which will contains an icon indicating which layout we're using.
   -- We need one layoutbox per screen.
   --
   mylayoutbox[s] = awful.widget.layoutbox(s)
   mylayoutbox[s]:buttons(awful.util.table.join(
                             awful.button({ }, 1,
                                          function () awful.layout.inc(layouts, 1) end),
                             awful.button({ }, 3,
                                          function () awful.layout.inc(layouts, -1) end),
                             awful.button({ }, 4,
                                          function () awful.layout.inc(layouts, 1) end),
                             awful.button({ }, 5,
                                          function () awful.layout.inc(layouts, -1) end)))
end

function taglist_init(s)
   -- Create a taglist widget
   mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)
end

function tasklist_init(s)
   -- Create a tasklist widget
   mytasklist[s] = awful.widget.tasklist(
      function(c)
         return awful.widget.tasklist.label.currenttags(c, s)
      end, mytasklist.buttons)

   -- Create a title bar
   titlebar[s] = awful.widget.tasklist(
      function(c)
         return awful.widget.tasklist.label.focused(c, s)
      end)
end

function wibox_bottom_init(s)
   wibox_bottom[s] = awful.wibox({ position = "bottom",
                                   height = 20,
                                   screen = s })
   -- wibox_bottom[s] = awful.wibox({ position = "left",
   --                                 align = "right",
   --                                 height = "96%",
   --                                 screen = s })
   wibox_bottom[s].widgets = {
      {
         mylauncher,
         layout = awful.widget.layout.horizontal.leftright
      },
      mylayoutbox[s],
      volume_display,
      battery_textbox,
      meminfo,
--      s == 1 and mysystray or nil,
      mytaglist[s],
      mypromptbox[s],
      layout = awful.widget.layout.horizontal.rightleft
   }
end

function wibox_top_init(s)
   wibox_top[s] = awful.wibox({ position = "top", screen = s })
   wibox_top[s].widgets = {
      mytextclock,
      s == 1 and mysystray or nil,
      -- mytaglist[s],
      mytasklist[s],
      -- titlebar[s],
      layout = awful.widget.layout.horizontal.rightleft
   }
end

taglist_init_buttons()
tasklist_init_buttons()
battery_widget_init()
volume_widget_init()
meminfo_init()

for s = 1, screen.count() do
   promptbox_init(s)
   layoutbox_init(s)
   taglist_init(s)
   tasklist_init(s)
   wibox_bottom_init(s)
   wibox_top_init(s)
end

wiboxes['bottom'] = wibox_bottom
wiboxes['top'] = wibox_top

-- }}}
