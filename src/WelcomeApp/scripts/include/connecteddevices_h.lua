--------------------------------------------------------------------------------
-- FUNCTIONS
-------------

local scan
local scanFinished
local startScanRunningProgressTimer
local scanRunningProgressTimerExpired
local getInterfaces
local setInterface
local setSelection
local configure
local deviceInfoToJson
local isOwnMacAddress

--------------------------------------------------------------------------------
-- SERVES
----------

Script.serveFunction(_APPNAME .. ".ConnectedDevices.getInterfaces", "getInterfaces")
Script.serveFunction(_APPNAME .. ".ConnectedDevices.scan", "scan")
Script.serveFunction(_APPNAME .. ".ConnectedDevices.setSelection", "setSelection")
Script.serveFunction(_APPNAME .. ".ConnectedDevices.configure", "configure")

Script.serveEvent(_APPNAME .. ".ConnectedDevices.ScanProgress", "ScanProgress")
Script.serveEvent(_APPNAME .. ".ConnectedDevices.ScanResults", "ScanResults")
Script.serveEvent(_APPNAME .. ".ConnectedDevices.ConfigureShow", "ConfigureShow")
Script.serveEvent(_APPNAME .. ".ConnectedDevices.ConfigureData", "ConfigureData")
Script.serveEvent(_APPNAME .. ".ConnectedDevices.ConfigureRunning", "ConfigureRunning")
Script.serveEvent(_APPNAME .. ".ConnectedDevices.ConfigureSuccess", "ConfigureSuccess")
