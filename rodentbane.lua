----------------------------------------------------------------------------
-- @author Lucas de Vries &lt;lucas@tuple-typed.org&gt;
-- @author Yang Ha Nguyen <cmpitg@gmail.com>
-- @copyright 2009-2010 Lucas de Vries
-- @copyright 2010-2010 Yang Ha Nguyen
--
-- Licensed under terms of the GPL v3
----------------------------------------------------------------------------

--
-- TODO:
--     + Add more documentation.
--
-- Changlog:
--     + Sun, 02 Jan 2011 14:00:54 +0700
--       - Better module organization.
--       - Added support for rebinding shortcuts.
--       - Fixed method calling.
--

require("awful")
require("beautiful")

-- Module interface
local M = {}

---- Grabbing the environment {{{
local ipairs = ipairs
local pairs = pairs
local print = print
local type = type
local tonumber = tonumber
local tostring = tostring
local unpack = unpack
local math = math
local table = table
local awful = awful
local os = os
local io = io
local string = string
local awful = awful
local beautiful = beautiful

-- Grab C API
local capi =
{
    root = root,
    awesome = awesome,
    screen = screen,
    client = client,
    mouse = mouse,
    button = button,
    titlebar = titlebar,
    widget = widget,
    hooks = hooks,
    keygrabber = keygrabber,
    wibox = wibox,
    widget = widget,
}

-- }}}

-- Local data
local bindings = {}
local history = {}
local current = nil
local wiboxes = nil
local borders = {"horiz", "vert", "left", "right", "top", "bottom"}
local default_color = "#C50B0B"

-- Create the wiboxes to display
function M.init()
    -- Wiboxes table
    wiboxes = {}

    -- Create wibox for each border
    for i, border in ipairs(borders) do
        wiboxes[border] = capi.wibox({
            bg = beautiful.rodentbane_bg or beautiful.border_focus or default_color,
            ontop = true,
        })
    end
end

--- Draw the guidelines on screen using wiboxes. {{{
-- @param area The area of the screen to draw on, defaults to current area.
local function draw(area)
   -- Default to current area
   local ar = area or current

   -- Get numbers
   local rwidth = beautiful.rodentbane_width or 2

   -- Stop if the area is too small
   if ar.width < rwidth * 3 or ar.height < rwidth * 3 then
      stop()
      return false
   end

   -- Put the wiboxes on the correct screen
   for border, box in pairs(wiboxes) do
      box.screen = ar.screen
   end

   -- Horizontal border
   wiboxes.horiz:geometry({
                             x = ar.x + rwidth,
                             y = ar.y + math.floor(ar.height / 2),
                             height = rwidth,
                             width = ar.width - (rwidth * 2),
                          })

   -- Vertical border
   wiboxes.vert:geometry({
                            x = ar.x + math.floor(ar.width / 2),
                            y = ar.y + rwidth,
                            width = rwidth,
                            height = ar.height - (rwidth * 2),
                         })

   -- Left border
   wiboxes.left:geometry({
                            x = ar.x,
                            y = ar.y,
                            width = rwidth,
                            height = ar.height,
                         })

   -- Right border
   wiboxes.right:geometry({
                             x = ar.x + ar.width - rwidth,
                             y = ar.y,
                             width = rwidth,
                             height = ar.height,
                          })

   -- Top border
   wiboxes.top:geometry({
                           x = ar.x,
                           y = ar.y,
                           height = rwidth,
                           width = ar.width,
                        })

   -- Bottom border
   wiboxes.bottom:geometry({
                              x = ar.x,
                              y = ar.y + ar.height - rwidth,
                              height = rwidth,
                              width = ar.width,
                           })
end
-- }}}

--- Cut the navigation area into a direction.
-- @param dir Direction to cut to {"up", "right", "down", "left"}. {{{
function M.cut(dir)
    -- Store previous area
    table.insert(history, 1, awful.util.table.join(current))

    -- Cut in a direction
    if dir == "up" then
        current.height = math.floor(current.height / 2)
    elseif dir == "down" then
        current.y = current.y + math.floor(current.height / 2)
        current.height = math.floor(current.height / 2)
    elseif dir == "left" then
        current.width = math.floor(current.width / 2)
    elseif dir == "right" then
        current.x = current.x + math.floor(current.width / 2)
        current.width = math.floor(current.width / 2)
    end

    -- Redraw the box
    draw(current)
 end
-- }}}

--- Move the navigation area in a direction.
-- @param dir Direction to move to {"up", "right", "down", "left"}.
-- @param ratio Ratio of movement, multiplied by the size of the current area, 
-- defaults to 0.5 (ie. half the area size. {{{
function M.move(dir, ratio)
   -- Store previous area
   table.insert(history, 1, awful.util.table.join(current))

   -- Default to ratio 0.5
   local rt = ratio or 0.5

   -- Move to a direction
   if dir == "up" then
      current.y = current.y - math.floor(current.height * rt)
   elseif dir == "down" then
      current.y = current.y + math.floor(current.height * rt)
   elseif dir == "left" then
      current.x = current.x - math.floor(current.width * rt)
   elseif dir == "right" then
      current.x = current.x + math.floor(current.width * rt)
   end

   -- Redraw the box
   draw(current)
end
-- }}}

--- Bind a key in rodentbane mode.
-- @param modkeys Modifier key combination to bind to.
-- @param key Main key to bind to.
-- @param func Function to bind the keys to. {{{
local function rd_bind(modkeys, key, func)
   -- Create binding
   local combination = {modkeys, key, func}

   -- Add to bindings table
   table.insert(bindings, combination)
end
-- }}}

--- Callback function for the keygrabber.
-- @param modkeys Modkeys that were pressed.
-- @param key Main key that was pressed.
-- @param evtype Pressed or released event. {{{
local function keyevent(modkeys, key, evtype)
   -- Ignore release events and modifier keys
   if evtype == "release" 
      or key == "Shift_L"
      or key == "Shift_R"
      or key == "Control_L"
      or key == "Control_R"
      or key == "Super_L"
      or key == "Super_R"
      or key == "Hyper_L"
      or key == "Hyper_R"
      or key == "Alt_L"
      or key == "Alt_R"
      or key == "Meta_L"
      or key == "Meta_R" then
      return true
   end

   -- Special cases for printable characters
   -- HACK: Maybe we need a keygrabber that gives keycodes ?
   if key == " " then
      key = "Space"
   end

   modkeys = modkeys or {}

   -- Figure out what to call
   for ind, bind in ipairs(bindings) do
      if bind[2]:lower() == key:lower() and M.table_equals(bind[1], modkeys) then
         -- Call the function
         if type(bind[3]) == "table" then
            -- Allow for easy passing of arguments
            local func = bind[3][1]
            local args = {}

            -- Add the rest of the arguments
            for i, arg in ipairs(bind[3]) do
               if i > 1 then
                  table.insert(args, arg)
               end
            end

            -- Call function with args
            func(unpack(args))
         else
            -- Call function directly
            bind[3]()
         end

         -- A bind was found, continue grabbing
         return true
      end
   end
   -- No key was found, stop grabbing
   M.stop()
   return false
end
-- }}}

--- Check if two tables have the same values.
-- @param t1 First table to check.
-- @param t2 Second table to check.
-- @return True if the tables are equivalent, false otherwise. {{{
function M.table_equals(t1, t2)
   -- Check first table
   for i, item in ipairs(t1) do
      if item ~= "Mod2" and
         awful.util.table.hasitem(t2, item) == nil then
         -- An unequal item was found
         return false
      end
   end

   -- Check second table
   for i, item in ipairs(t2) do
      if item ~= "Mod2" and 
         awful.util.table.hasitem(t1, item) == nil then
         -- An unequal item was found
         return false
      end
   end

   -- All items were equal
   return true
end
-- }}}

--- Warp the mouse to the center of the navigation area {{{
function M.warp()
   capi.mouse.coords({
                        x = current.x + (current.width / 2),
                        y = current.y + (current.height / 2),
                     })
end
-- }}}

--- Click with a button
-- @param button Button number to click with, defaults to left (1) {{{
function M.click(button)
   -- Default to left click
   local b = button or 1

   -- TODO: Figure out a way to use fake_input for clicks
   --capi.root.fake_input("button_press", button)
   --capi.root.fake_input("button_release", button)

   -- Use xdotool when available, otherwise try xte
   command = "xdotool click " .. b .. " &> /dev/null"
      .. " || xte 'mouseclick " .. b .. "' &> /dev/null"
      .. " || echo 'W: rodentbane: either xdotool or xte"
      .. " is required to emulate mouse clicks, neither was found.'"

   awful.util.spawn_with_shell(command)
end
-- }}}

--- Undo a change to the area {{{
function M.undo()
    -- Restore area
    if #history > 0 then
        current = history[1]
        table.remove(history, 1)

        draw(current)
    end
 end
-- }}}

--
-- Mouse click functions
-- This has to be clear, especially with users who swap mouse keys {{{
--
function M.first_click()
   M.warp()
   M.click()
   M.stop()
end
-- Secondary click
function M.sec_click()
   M.warp()
   M.click(3)
   M.stop()
end
-- Middle click
function M.middle_click()
   M.warp()
   M.click(2)
   M.stop()
end
-- Double firstclick
function M.double_first_click()
   M.warp()
   M.click()
   M.click()
   M.stop()
end
-- Double sec_click
function M.double_sec_click()
   M.warp()
   M.click(3)
   M.click(3)
   M.stop()
end
-- }}}

--- Convenience function to bind to default keys. {{{
function M.bind_default()
   -- Cut with hjkl
   rd_bind({}, "h", {M.cut, "left"})
   rd_bind({}, "j", {M.cut, "down"})
   rd_bind({}, "k", {M.cut, "up"})
   rd_bind({}, "l", {M.cut, "right"})

   -- Move with Shift+hjkl
   rd_bind({"Shift"}, "h", {M.move, "left"})
   rd_bind({"Shift"}, "j", {M.move, "down"})
   rd_bind({"Shift"}, "k", {M.move, "up"})
   rd_bind({"Shift"}, "l", {M.move, "right"})

   -- Undo with u
   rd_bind({}, "u", M.undo)

   -- Left click with space
   rd_bind({}, "Space", M.sec_click)

   -- Middle click with Control+space
   rd_bind({"Control"}, "Space", M.middle_click)

   -- Right click with shift+space
   rd_bind({"Shift"}, "Space", M.first_click)

   -- Only warp with return
   rd_bind({}, "Return", M.warp)
end
-- }}}

--- Start the navigation sequence.
-- @param screen Screen to start navigation on, defaults to current screen.
-- @param recall Whether the previous area should be recalled (defaults to 
-- false). {{{
function M.start(screen, recall)
   -- Default to current screen
   local scr = screen or capi.mouse.screen

   -- Initialise if not already done
   if wiboxes == nil then
      -- Add default bindings if we have none ourselves
      if #bindings == 0 then
         M.bind_default()
      end

      -- Create the wiboxes
      M.init()
   end

   -- Empty current area if needed
   if not recall then
      -- Start with a complete area
      current = capi.screen[scr].workarea

      -- Empty history
      history = {}
   end

   -- Move to the right screen
   current.screen = scr

   -- Start the keygrabber
   capi.keygrabber.run(keyevent)

   -- Draw the box
   draw(current)
end
--- }}}

--- Stop the navigation sequence without doing anything. {{{
function M.stop()
    -- Stop the keygrabber
    capi.keygrabber.stop()

    -- Hide all wiboxes
    for border, box in pairs(wiboxes) do
        box.screen = nil
    end
 end
-- }}}

return M
