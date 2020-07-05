require("include/pingtest_h")

--------------------------------------------------------------------------------
-- VARIABLES
-------------

local resetTimer = Timer.create()
resetTimer:register("OnExpired", "reset")
resetTimer:setExpirationTime(10e3)

--------------------------------------------------------------------------------
-- FUNCTIONS
-------------

--@ping()
--[[
No description yet...
--]]
ping = function()
  local args = Parameters.getNode("PingTest/ping")
  local success, responseTimeMs = Ethernet.ping(args:get("ipAddress"), args:get("timeoutMs"), args:get("ifName"), args:get("payloadSizeBytes"))

  Script.notifyEvent("ResultShow", true)
  Script.notifyEvent("ResultSuccess", success)
  Script.notifyEvent("ResultTime", ((responseTimeMs == nil) and "" or responseTimeMs .. " ms"))

  resetTimer:start()
end

--@reset()
--[[
No description yet...
--]]
reset = function()
  Script.notifyEvent("ResultShow", false)
end

--@getInterfaces()
--[[
No description yet...
--]]
getInterfaces = function()
  local ethernetInterfaces = Engine.getEnumValues("EthernetInterfaces")
  local j = {"[{\"label\":\"ALL\",\"value\":\"ALL\"}"}
  for _, v in pairs(ethernetInterfaces) do
    j[#j+1] = ",{" .. "\"label\":\"" .. v .. "\",\"value\":\"" .. v .. "\"}"
  end
  return table.concat(j) .. "]"
end