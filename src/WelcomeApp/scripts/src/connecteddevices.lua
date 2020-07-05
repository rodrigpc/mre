require("include/connecteddevices_h")

require("src/util/str")
local JSON = require("src/util/json")

--------------------------------------------------------------------------------
-- VARIABLES
-------------

local macAddresses = {}
local ethernetInterfaces = Engine.getEnumValues("EthernetInterfaces")

local scanner = Command.Scan.create() -- create the handle used for scanning, configuring and beeping
local scannerTimeout = 1000 -- ms
local scanRunningProgressTimer = nil
local scanRunningProgressCur = 0
local scanRunningProgressMax = scannerTimeout / 1000 * (#ethernetInterfaces + 1)

local scanAsyncHandle = nil
local scanFutureHandle = nil

local devices = {}
local deviceSelection = nil

--------------------------------------------------------------------------------
-- FUNCTIONS
-------------

--@scan()
--[[
This function is used to scan for devices via the specified interface.
After the scan is finished, the results are serialized into JSON and published 
via the event "ScanChanged".
--]]
scan = function()
    devices = {}
    deviceSelection = nil
    
    Script.notifyEvent("ScanResults", "[]")
    Script.notifyEvent("ConfigureShow", false)
    
    startScanRunningProgressTimer()
    scanner:setInterface(Parameters.get("ConnectedDevices/scanInterface"))
    if (scanAsyncHandle == nil) then
        scanAsyncHandle = Engine.AsyncFunction.create()
        scanAsyncHandle:setFunction("Command.Scan.scan", scanner)
        scanAsyncHandle:register("OnFinished", scanFinished)
    end
    scanFutureHandle = scanAsyncHandle:launch(scannerTimeout)
end

--@scanFinished()
--[[
No description yet...
--]]
scanFinished = function()
    devices = scanFutureHandle:wait()
    scanRunningProgressCur = 100
    Script.notifyEvent("ScanProgress", 100)
    Script.notifyEvent("ScanResults", deviceInfoToJson(devices))
end

--@startScanRunningProgressTimer()
--[[
No description yet...
--]]
startScanRunningProgressTimer = function()
    if (scanRunningProgressTimer == nil) then
        scanRunningProgressTimer = Timer.create()
        scanRunningProgressTimer:register("OnExpired", scanRunningProgressTimerExpired)
        scanRunningProgressTimer:setExpirationTime(scannerTimeout)
        scanRunningProgressTimer:setPeriodic(true)
    end
    scanRunningProgressCur = 0
    Script.notifyEvent("ScanProgress", 0)
    scanRunningProgressTimer:start()
end

--@scanRunningProgressTimerExpired()
--[[
No description yet...
--]]
scanRunningProgressTimerExpired = function()
    scanRunningProgressCur = scanRunningProgressCur + 1
    if (scanRunningProgressCur >= scanRunningProgressMax) then
        scanRunningProgressTimer:stop()
        Script.notifyEvent("ScanProgress", 100)
    else
        Script.notifyEvent("ScanProgress", math.floor(100 * scanRunningProgressCur / scanRunningProgressMax))
    end
end

--@getInterfaces()
--[[
No description yet...
--]]
getInterfaces = function()
    local j = {{label = "ALL", value = "ALL"}}
    for _, v in pairs(ethernetInterfaces) do j[#j + 1] = {label = v, value = v} end
return JSON.stringify(j)
end

--@setSelection(selection: string)
--[[
This function is triggered, when the user selects a row in the table.
The table row number is passed as argument.
--]]
setSelection = function(index)
    deviceSelection = index
    local dev = devices[index]
    Script.notifyEvent("ConfigureData", deviceInfoToJson({dev}))
    Script.notifyEvent("ConfigureShow", true)
    Parameters.set("ConnectedDevices/configure/dhcp", dev:getDHCPClientEnabled())
    Parameters.set("ConnectedDevices/configure/ipAddress", dev:getIPAddress())
    Parameters.set("ConnectedDevices/configure/subnetMask", dev:getSubnetMask())
    Parameters.set("ConnectedDevices/configure/defaultGateway", dev:getDefaultGateway())
    Parameters.apply()
end

--@configure(): bool
--[[
No description yet...
--]]
configure = function()
    local dev = devices[deviceSelection]
    local args = Parameters.getNode("ConnectedDevices/configure")
    
    Script.notifyEvent("ConfigureRunning", true)
    local success = Command.Scan.configure(scanner, dev:getMACAddress(), args:get("ipAddress"), args:get("subnetMask"), args:get("defaultGateway"), args:get("dhcp"))
    Script.notifyEvent("ConfigureRunning", false)
    
    Script.notifyEvent("ConfigureSuccess", "#configuration.connecteddevices.configure." .. (success and "successful" or "failed"))
    scan()
    -- TODO: Add a timer here
    Script.notifyEvent("ConfigureSuccess", "")
    
    return success
end

--@deviceInfoToJson(devices: userdata): string
--[[
Create the string representing the devices for displaying in tabelview
--]]
deviceInfoToJson = function(deviceInfo)
    local j = {}
    for k, v in pairs(deviceInfo) do
        if (not isOwnMacAddress(Command.Scan.DeviceInfo.getMACAddress(v))) then
            local ethIf = Command.Scan.DeviceInfo.getEthernetInterface(v)
            j[k] = {
                deviceName = tostr(Command.Scan.DeviceInfo.getDeviceName(v)),
                ethernetInterface = ethIf .. " &rarr; " .. Ethernet.getInterfaceConfig(ethIf),
                locationName = tostr(Command.Scan.DeviceInfo.getLocationName(v)),
                serialNumber = tostr(Command.Scan.DeviceInfo.getSerialNumber(v)),
                firmwareVersion = tostr(Command.Scan.DeviceInfo.getFirmwareVersion(v)),
                macAddress = Command.Scan.DeviceInfo.getMACAddress(v),
                ipAddress = Command.Scan.DeviceInfo.getIPAddress(v),
                subnetMask = Command.Scan.DeviceInfo.getSubnetMask(v),
                defaultGateway = Command.Scan.DeviceInfo.getDefaultGateway(v),
            dhcpEnabled = Command.Scan.DeviceInfo.getDHCPClientEnabled(v)}
        end
    end
    return JSON.stringify(j)
end

--@isOwnMacAddress(macAddress: string): bool
--[[
Return true if macAddress belongs to myself.
--]]
isOwnMacAddress = function(macAddress)
    if (#macAddresses == 0) then
        for _, v in pairs(ethernetInterfaces) do
            _, _, _, ifMac = Ethernet.getInterfaceConfig(v)
            macAddresses[ifMac:lower():gsub("-", ""):gsub(":", "")] = true
        end
    end
    return macAddresses[macAddress:lower():gsub("-", ""):gsub(":", "")]
end
