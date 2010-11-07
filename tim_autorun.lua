-- cmpitg's autorun programs, just once {{{
autorun = true
autorunApps = {
   "gnote", "gnome-gmail-notifier",
   "xcompmgr", "gnome-settings-daemon"
}

function spawn_once(prg)
   if not prg then
      do return nil end
   end
   -- awful.util.spawn_with_shell("pgrep -u $USER -x "
   --                             .. prg .. " || (" .. prg .. ")")
   awful.util.spawn_with_shell("ps aux | grep "
                               .. prg .. " | grep -v grep | awk '{ print $2 }' || ("
                               .. prg .. ")")
end

if autorun then
   for app in autorunApps do
      spawn_once(app)
   end
end
-- }}}
