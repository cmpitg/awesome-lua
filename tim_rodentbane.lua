local rd = require 'rodentbane'
rd.bind_default()
require("tim_key_bindings")
globalkeys = awful.util.table.join(
   globalkeys,
   awful.key({ modkey, "Control" }, "r", rc.start)
)
