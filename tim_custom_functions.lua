--
-- Prompt menus for man page
--
-- awful.key({ modkey }, "F4",
--           function ()
--              awful.prompt.run({ prompt = "Manual: " },
--                               mypromptbox[mouse.screen].widget,
--                               -- Use GNU Emacs for displaying manpage
--                               -- function (page) awful.util.spawn("emacsclient --eval '(manual-entry \"'"
--                               -- .. page .. "'\")'", false) end,
--                               --
--                               -- Use x-terminal-emulator for manual page display
--                               -- function (page) awful.util.spawn("x-terminal-emulator -e man "
--                               -- .. page, false) end,
--                               --
--                               function (page)
--                                  awful.util.spawn("x-terminal-emulator -e man" .. page, false)
--                               end

--                               function (cmd, cur_pos, ncomp)
--                                  local pages = {}
--                                  local m = 'IFS=: && find $(manpath || echo "$MANPATH") -type f -printf "%f\n" | cut -d. -f1'
--                                  local c, err = io.popen(m)
--                                  if c then
--                                     while true do
--                                        local manpage = c:read("*line")
--                                        if not manpage then
--                                           break
--                                        end
--                                        if manpage:find("^" .. cmd:sub(1, cur_pos)) then
--                                           table.insert(pages, manpage)
--                                        end
--                                     end
--                                     c:close()
--                                  else
--                                     io.stderr:write(err)
--                                  end
--                                  if #cmd == 0 then
--                                     return cmd, cur_pos
--                                  end
--                                  if #pages == 0 then
--                                     return
--                                  end
--                                  while ncomp > #pages do
--                                     ncomp = ncomp - #pages
--                                  end
--                                  return pages[ncomp], cur_pos
--                               end)
--           end)

-- awful.key({ modkey }, "F4", function ()
--     awful.prompt.run({ prompt = "Manual: " }, mypromptbox[mouse.screen].widget,
--     --  Use GNU Emacs for manual page display
--     --  function (page) awful.util.spawn("emacsclient --eval '(manual-entry \"'" .. page .. "'\")'", false) end,
--     --  Use the KDE Help Center for manual page display
--     --  function (page) awful.util.spawn("khelpcenter man:" .. page, false) end,
--     --  Use the terminal emulator for manual page display
--         function (page) awful.util.spawn("urxvt -e man " .. page, false) end,
--         function(cmd, cur_pos, ncomp)
--             local pages = {}
--             local m = 'IFS=: && find $(manpath||echo "$MANPATH") -type f -printf "%f\n"| cut -d. -f1'
--             local c, err = io.popen(m)
--             if c then while true do
--                 local manpage = c:read("*line")
--                 if not manpage then break end
--                 if manpage:find("^" .. cmd:sub(1, cur_pos)) then
--                     table.insert(pages, manpage)
--                 end
--               end
--               c:close()
--             else io.stderr:write(err) end
--             if #cmd == 0 then return cmd, cur_pos end
--             if #pages == 0 then return end
--             while ncomp > #pages do ncomp = ncomp - #pages end
--             return pages[ncomp], cur_pos
--         end)
-- end),