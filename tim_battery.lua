--
-- Author: Yang Ha Nguyen
-- Date: Fri, 26 Nov 2010 10:46:56 +0700
--
-- Description:
--     A battery monitoring widget for Awesome window manager
--

require("naughty")
require("beautiful")

local io = io
local math = math
local naughty = naughty
local beautiful = beautiful

module("tim_battery")

local limits = {{25, 5}, {12, 3}, {7, 1}, {0}}
local limits_num = 4
local lim = 0
local step = 0
local nextlim = 0

function make_powersup_path(adapter, filename)
   return "/sys/class/power_supply/" .. adapter .. "/" .. filename
end

function get_battery_status(adapter)
   local stat = ""
   local fcurrent = io.open(make_powersup_path(adapter, "/charge_now"), "r")
   local fcapacity = io.open(make_powersup_path(adapter, "/charge_full"), "r")
   local fstatus = io.open(make_powersup_path(adapter, "/status"), "r")
   local current = fcurrent:read()
   local capacity = fcapacity:read()
   local status = fstatus:read()
   fcurrent:close()
   fcapacity:close()
   fstatus:close()

   local battery = math.floor(current * 100 / capacity)
   if status:match("Charging") then
      stat = "©"
   elseif status:match("Discharging") then
      stat = "€"
   else
      stat = "⚡"
   end

   return battery, stat
end

function get_next_limit(num)
   local ind = 1
   for ind = 1, #limits - 1 do
      local pair = limits[ind]
      lim = pair[1]
      step = pair[2]
      nextlim = limits[ind + 1][1] or 0
      if num > nextlim then
         repeat
            lim = lim - step
         until num > lim
         if lim < nextlim then
            lim = nextlim
         end
         return lim
      end
   end
end

function battery_closure(adapter)
   local nextlim = limits[1][1]
   return function ()
             local prefix = "⚡"
             local battery, stat = get_battery_status(adapter)
             nextlim = nextlim or 20
             if stat:match("€") then
                if battery <= nextlim then
                   naughty.notify({ title = "⚡ Beware! ⚡",
                                    text = "Battery charge is low (⚡" .. battery .. "%)!!!",
                                    timeout = 7,
                                    position = "bottom_right",
                                    fg = beautiful.fg_focus,
                                    bg = beautiful.bg_focus })
                   nextlim = get_next_limit(battery)
                end
             elseif stat:match("©") then
                nextlim = limits[1][1]
             end
             return '<span color="orange">' .. battery .. stat .. ' </span>'
          end
end
