--------------------------------------------------------------------------------
-- FUNCTIONS
-------------

local ping
local reset
local getInterfaces

--------------------------------------------------------------------------------
-- SERVES
----------

Script.serveFunction(_APPNAME .. ".PingTest.ping", "ping")
Script.serveFunction(_APPNAME .. ".PingTest.getInterfaces", "getInterfaces")

Script.serveEvent(_APPNAME .. ".PingTest.ResultShow", "ResultShow")
Script.serveEvent(_APPNAME .. ".PingTest.ResultSuccess", "ResultSuccess")
Script.serveEvent(_APPNAME .. ".PingTest.ResultTime", "ResultTime")