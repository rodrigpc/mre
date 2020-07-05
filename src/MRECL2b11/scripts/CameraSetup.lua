--luacheck: ignore gDirectoryProvider gJobs gActualJob gCam gHandleOnNewImageProcessing gConfig
--luacheck: ignore gIsConnected gSetAcquisitionMode

--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************

-- Info to connecte and set IP of camera
local camera_ipAddress, camera_macAddress, camera_defaultGateway, camera_dhcp, camera_devName

-- Scanner for IP-Camera on Interface ETH2
local scanner = Command.Scan.create()
scanner:setInterface("ETH2")

-- Directory Provider for Offline-Images
gDirectoryProvider:setCycleTime(1000)
gDirectoryProvider:setPath("resources/SampleImg", "jpg")
--**************************************************************************
--**********************End Global Scope ***********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

--@setCameraConfig():
-- Function to set camera configuration
local function setCameraConfig()
  -- Creation of configuration handle
  gConfig = Image.Provider.RemoteCamera.I2DConfig.create()
  gConfig:setShutterTime(gJobs[gActualJob]["shutterTime"])
  gSetAcquisitionMode(gJobs[gActualJob]["triggerMode"])
  gConfig:setGainFactor(gJobs[gActualJob]["gain"])
  gConfig:setColorMode("COLOR8")

  if gIsConnected == false then
    -- Creation of remote camera handle
    gCam = Image.Provider.RemoteCamera.create()
    gCam:setType('I2DCAM')
    gCam:setIPAddress(gJobs[gActualJob]["camIP"])
    gCam:setConfig(gConfig)
  else
    gCam:stop()
    gCam:setConfig(gConfig)
    gCam:start()
  end
end
Script.serveFunction("ColorSorter.setCameraConfig", setCameraConfig)

--@connectCamera():
-- Function to connect to camera
local function connectCamera()
  Script.notifyEvent("OnSearchForCamera", false)
  -- Connection to camera. When the camera can connect, starting the acquisition
  print("Start to connect to camera")
  gIsConnected = gCam:connect()
  if gIsConnected then
    print('Connection to camera successed')
    Script.notifyEvent("OnFoundCamera", true)
    gCam:start()
  else
    print('Connection to camera failed')
    Script.notifyEvent("OnFoundCamera", false)
  end
  Script.notifyEvent("OnSearchForCamera", true)
end
Script.serveFunction("ColorSorter.connectCamera", connectCamera)

--@scanForCameraIp():
-- Function to scan for connected camera on ETH2
local function scanForCameraIp()
  Script.notifyEvent("OnScanForCamera", true)
  local devices = scanner:scan()
  
  if #devices >=1 then
    camera_macAddress = Command.Scan.DeviceInfo.getMACAddress(devices[1])
    camera_ipAddress = Command.Scan.DeviceInfo.getIPAddress(devices[1])
    --camera_subnetMask = Command.Scan.DeviceInfo.getSubnetMask(devices[1])
    camera_defaultGateway = Command.Scan.DeviceInfo.getDefaultGateway(devices[1])
    camera_dhcp = Command.Scan.DeviceInfo.getDHCPClientEnabled(devices[1])
    camera_devName = Command.Scan.DeviceInfo.getDeviceName(devices[1])

    Script.notifyEvent("OnFoundCameraWithScan", "Device: " .. camera_devName .. ", with IP " .. camera_ipAddress)
    Script.notifyEvent("OnReadyToSendIpToCamera", true)

  else
    Script.notifyEvent("OnFoundCameraWithScan", "No camera found")
  end
  Script.notifyEvent("OnScanForCamera", false)

end
Script.serveFunction("ColorSorter.scanForCameraIp", scanForCameraIp)

--@sendIpToCamera():
-- Function to send IP-Address to connected camera
local function sendIpToCamera()
  Script.notifyEvent("OnScanForCamera", true)
  Image.Provider.RemoteCamera.deregister(gCam, "OnNewImage", gHandleOnNewImageProcessing)
  Script.releaseObject(gCam)
  local success = Command.Scan.configure(scanner, camera_macAddress, gJobs[gActualJob]["camIP"], gJobs[gActualJob]["camSubnet"], camera_defaultGateway, camera_dhcp)
  
  if success then
    Script.notifyEvent("OnSetCamIpSuccess", true)
    Script.notifyEvent("OnSetCamIpVisible", true)
  else
    Script.notifyEvent("OnSetCamIpSuccess", false)
    Script.notifyEvent("OnSetCamIpVisible", true)
  end
  Script.notifyEvent("OnFoundCameraWithScan", "")

  gCam = Image.Provider.RemoteCamera.create()
  gCam:setType('I2DCAM')
  gCam:setIPAddress(gJobs[gActualJob]["camIP"])

  ColorSorter.setCameraConfig()
  ColorSorter.connectCamera()

  Image.Provider.RemoteCamera.register(gCam, "OnNewImage", gHandleOnNewImageProcessing)
  Script.notifyEvent("OnScanForCamera", false)
end
Script.serveFunction("ColorSorter.sendIpToCamera", sendIpToCamera)

--**************************************************************************
--**********************End Function Scope *********************************
--**************************************************************************