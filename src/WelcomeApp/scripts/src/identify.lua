require("include/identify_h")

--------------------------------------------------------------------------------
-- FUNCTIONS
-------------

--@blink()
--[[
No description yet...
--]]
blink = function()
  local scanner = Command.Scan.create()
  scanner:setInterface("ETH1")
  local _, _, _, macAddress = Ethernet.getInterfaceConfig("ETH1")
  return Command.Scan.beep(scanner, macAddress:gsub("-", ":"))
end