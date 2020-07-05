--luacheck: ignore gS1 gCam gS2 gJobs gActualJob gS3 gS4 gDigOut4 gETH2 gCamTriggerFlow gHandleOnNewImageProcessing gSysType

--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************

require("GlobalVariables")
require("ObjectClass")

-- Get SIM type
local typeName = Engine.getTypeName()
local simType = string.sub(typeName, 1, 7)
print(typeName)

-- Decide if SIM type supports camera trigger
if simType == "SIM1004" then
  gSysType = 1
elseif simType == "SIM1012" then
  gSysType = 2
  gCamTriggerFlow:load("resources/CameraTrigger.cflow")
elseif simType == "SIM4000" then
  gSysType = 3
  gCamTriggerFlow:load("resources/CameraTrigger.cflow")
elseif typeName == "AppStudioEmulator" then
  gSysType = 4
  simType = "Emulator"
end

-- Power for Illumination
if gSysType ~= 4 then
   gS1 = Connector.Power.create("S1")

  -- Power for Camera
  if simType == "SIM4000" then
    gS2 = Connector.Power.create("S2")
    gS2:enable(true)
    gETH2 = Connector.Power.create("POE2")
    gETH2:enable(false)
  elseif simType == "SIM1012" then
    gS2 = Connector.Power.create("S2")
    gS2:enable(true)
  elseif simType == "SIM1004" then
    gETH2 = Connector.Power.create("POE2")
    gETH2:enable(true)
  end

  -- Wait for camera boot-up
  Script.sleep(8000)

  -- Sensor Input
  gS3 = Connector.Power.create("S3")

  -- Sensor Output
  gS4 = Connector.Power.create("S4")
  gDigOut4 = Connector.DigitalOut.create("S4DO1")
end

require("UI_Events_Functions")
require("ImageProcessing")
if gSysType ~= 4 then
  require("CameraSetup")
end
require("Communication")

--**************************************************************************
--**********************End Global Scope ***********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

-- Function to connect to camera and get ready after System boot up
local function main()
  if gSysType ~= 4 then
    ColorSorter.setCameraConfig()
    ColorSorter.connectCamera()
    gS1:enable(true)
    Image.Provider.RemoteCamera.register(gCam, "OnNewImage", gHandleOnNewImageProcessing)
    --ColorSorter.createTCPsocket(gJobs[gActualJob]["tcpIpActive"])
    gS4:enable(gJobs[gActualJob]["digOutActive"])
  end
  ColorSorter.createTCPsocket(gJobs[gActualJob]["tcpIpActive"])
end
Script.register("Engine.OnStarted", main)

--@getSystemType():
-- Get System info and show on UI
local function getSystemType()
  Script.notifyEvent("OnShowConnectedSystem", gSysType)
  return "Found " .. simType
end
Script.serveFunction("ColorSorter.getSystemType", getSystemType)

--**************************************************************************
--**********************End Function Scope *********************************
--**************************************************************************