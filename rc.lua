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

require("tim_tags_config")
require("tim_theme")
require("tim_menu")
require("tim_global_mouse_bindings")
require("tim_client_mouse_bindings")
require("tim_wibox")

-- Rodentbane for mouse controlling from keyboard
-- require("tim_rodentbane")

require("tim_key_bindings")
require("tim_custom_functions")

--
-- Set keys
--
-- This command is very important
root.keys(globalkeys)
-- }}}

require("tim_client_rules")
require("tim_signals")

--awful.util.spawn("/usr/bin/nm-applet --sm-disable &")
awful.util.spawn("/home/cmpitg/bin/tim_xdmautostart")

-- require("tim_autorun")

-- Set desktop background
-- awful.util.spawn("/home/cmpitg/bin/tim_setbg")

-- Testing stuff
-- require("tim_test")
