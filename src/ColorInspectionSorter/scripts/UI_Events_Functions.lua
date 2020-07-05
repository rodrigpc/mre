--luacheck: ignore gJobs gActualJob gOfflineDemoModeActive gHandleOnNewImageProcessing gTempImage gActualColor gSelectRegionColor gColorSelecterActive gDirectoryProvider
--luacheck: ignore gCamSetupViewerActive gResultViewerActive gProcessResults gRoiEditorActive gViewerImageID gInstalledEditorIconic gTcpClient gS4 gCam gIsConnected gConfig
--luacheck: ignore gCamTriggerFlow gSetAcquisitionMode gS3 gOrgViewer gResViewer gConfigViewer gCamSetupViewer gCheckIfOfflineMode

--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************
local objectA = 1
local objectB = 2
local objectC = 3
local objectD = 4

local imgCounter = 1
local offlineSampleMode = true

local showAOI = true
local imageToShow = 1 --> 1=Hue 2=Saturation 3=Value
local colorMode = 1 -- 1 = Color, 2 = Grayvalue

--****************************************
-- Camera Setup
--****************************************
Script.serveEvent("ColorSorter.OnFoundCamera", "OnFoundCamera")
Script.serveEvent("ColorSorter.OnSearchForCamera", "OnSearchForCamera")
Script.serveEvent("ColorSorter.OnScanForCamera", "OnScanForCamera")
Script.serveEvent("ColorSorter.OnFoundCameraWithScan", "OnFoundCameraWithScan")
Script.serveEvent("ColorSorter.OnReadyToSendIpToCamera", "OnReadyToSendIpToCamera")
Script.serveEvent("ColorSorter.OnSetCamIpSuccess", "OnSetCamIpSuccess")
Script.serveEvent("ColorSorter.OnSetCamIpVisible", "OnSetCamIpVisible")
Script.serveEvent("ColorSorter.OnFrameRateActive", "OnFrameRateActive")
Script.serveEvent("ColorSorter.OnShowConnectedSystem", "OnShowConnectedSystem")
Script.serveEvent("ColorSorter.OnSwTriggerVisible", "OnSwTriggerVisible")
Script.serveEvent("ColorSorter.OnOfflineDemoModeActive", "OnOfflineDemoModeActive")
Script.serveEvent("ColorSorter.OnCameraSetupViewerActive", "OnCameraSetupViewerActive")

--****************************************
-- Image Processing
--****************************************
Script.serveEvent("ColorSorter.OnNewJobSelectedJobName", "OnNewJobSelectedJobName")

Script.serveEvent("ColorSorter.OnNewJobSelectedCamIP", "OnNewJobSelectedCamIP")
Script.serveEvent("ColorSorter.OnNewJobSelectedTriggerMode", "OnNewJobSelectedTriggerMode")
Script.serveEvent("ColorSorter.OnNewJobSelectedShutterTime", "OnNewJobSelectedShutterTime")
Script.serveEvent("ColorSorter.OnNewJobSelectedFramerate", "OnNewJobSelectedFramerate")
Script.serveEvent("ColorSorter.OnNewJobSelectedGain", "OnNewJobSelectedGain")
Script.serveEvent("ColorSorter.OnNewJobSelectedScaleFactor", "OnNewJobSelectedScaleFactor")

Script.serveEvent("ColorSorter.OnNewJobSelectedForegroundImage", "OnNewJobSelectedForegroundImage")
Script.serveEvent("ColorSorter.OnNewJobSelectedBackgroundImage", "OnNewJobSelectedBackgroundImage")

Script.serveEvent("ColorSorter.OnNewJobSelectedForegroundMin", "OnNewJobSelectedForegroundMin")
Script.serveEvent("ColorSorter.OnNewJobSelectedForegroundMax", "OnNewJobSelectedForegroundMax")
Script.serveEvent("ColorSorter.OnNewJobSelectedBackgroundMin", "OnNewJobSelectedBackgroundMin")
Script.serveEvent("ColorSorter.OnNewJobSelectedBackgroundMax", "OnNewJobSelectedBackgroundMax")
Script.serveEvent("ColorSorter.OnNewJobSelectedActualColor", "OnNewJobSelectedActualColor")
Script.serveEvent("ColorSorter.OnNewJobSelectedActualColorActive", "OnNewJobSelectedActualColorActive")

Script.serveEvent("ColorSorter.OnNewObjectA", "OnNewObjectA")
Script.serveEvent("ColorSorter.OnNewObjectB", "OnNewObjectB")
Script.serveEvent("ColorSorter.OnNewObjectC", "OnNewObjectC")
Script.serveEvent("ColorSorter.OnNewObjectD", "OnNewObjectD")

Script.serveEvent("ColorSorter.OnNewJobSelectedColor1Active", "OnNewJobSelectedColor1Active")
Script.serveEvent("ColorSorter.OnNewJobSelectedColor2Active", "OnNewJobSelectedColor2Active")
Script.serveEvent("ColorSorter.OnNewJobSelectedColor3Active", "OnNewJobSelectedColor3Active")
Script.serveEvent("ColorSorter.OnNewJobSelectedColor4Active", "OnNewJobSelectedColor4Active")

Script.serveEvent("ColorSorter.OnNewJobSelectedActualColorRoiActive", "OnNewJobSelectedActualColorRoiActive")
Script.serveEvent("ColorSorter.OnNewJobSelectedActualColorValue", "OnNewJobSelectedActualColorValue")
Script.serveEvent("ColorSorter.OnNewJobSelectedActualColorTolerance", "OnNewJobSelectedActualColorTolerance")
Script.serveEvent("ColorSorter.OnNewJobSelectedActualColorBlobSize", "OnNewJobSelectedActualColorBlobSize")
Script.serveEvent("ColorSorter.OnNewJobSelectedActualColorMaxBlobSize", "OnNewJobSelectedActualColorMaxBlobSize")
Script.serveEvent("ColorSorter.OnNewJobSelectedActualColorMinBlobSize", "OnNewJobSelectedActualColorMinBlobSize")

Script.serveEvent("ColorSorter.OnNewJobSelectedMinBlobGood1", "OnNewJobSelectedMinBlobGood1")
Script.serveEvent("ColorSorter.OnNewJobSelectedMinBlobGood2", "OnNewJobSelectedMinBlobGood2")
Script.serveEvent("ColorSorter.OnNewJobSelectedMinBlobGood3", "OnNewJobSelectedMinBlobGood3")
Script.serveEvent("ColorSorter.OnNewJobSelectedMinBlobGood4", "OnNewJobSelectedMinBlobGood4")
Script.serveEvent("ColorSorter.OnNewJobSelectedMaxBlobGood1", "OnNewJobSelectedMaxBlobGood1")
Script.serveEvent("ColorSorter.OnNewJobSelectedMaxBlobGood2", "OnNewJobSelectedMaxBlobGood2")
Script.serveEvent("ColorSorter.OnNewJobSelectedMaxBlobGood3", "OnNewJobSelectedMaxBlobGood3")
Script.serveEvent("ColorSorter.OnNewJobSelectedMaxBlobGood4", "OnNewJobSelectedMaxBlobGood4")

Script.serveEvent("ColorSorter.OnNewBlobsColor1", "OnNewBlobsColor1")
Script.serveEvent("ColorSorter.OnNewBlobsColor2", "OnNewBlobsColor2")
Script.serveEvent("ColorSorter.OnNewBlobsColor3", "OnNewBlobsColor3")
Script.serveEvent("ColorSorter.OnNewBlobsColor4", "OnNewBlobsColor4")
Script.serveEvent("ColorSorter.OnNewBlobsActualColor", "OnNewBlobsActualColor")

Script.serveEvent("ColorSorter.OnNewBlobsActualColorMinBlob", "OnNewBlobsActualColorMinBlob")
Script.serveEvent("ColorSorter.OnNewBlobsActualColorMaxBlob", "OnNewBlobsActualColorMaxBlob")
Script.serveEvent("ColorSorter.OnNewBlobsColorMinBlob1", "OnNewBlobsColorMinBlob1")
Script.serveEvent("ColorSorter.OnNewBlobsColorMinBlob2", "OnNewBlobsColorMinBlob2")
Script.serveEvent("ColorSorter.OnNewBlobsColorMinBlob3", "OnNewBlobsColorMinBlob3")
Script.serveEvent("ColorSorter.OnNewBlobsColorMinBlob4", "OnNewBlobsColorMinBlob4")

Script.serveEvent("ColorSorter.OnNewBlobsColorMaxBlob1", "OnNewBlobsColorMaxBlob1")
Script.serveEvent("ColorSorter.OnNewBlobsColorMaxBlob2", "OnNewBlobsColorMaxBlob2")
Script.serveEvent("ColorSorter.OnNewBlobsColorMaxBlob3", "OnNewBlobsColorMaxBlob3")
Script.serveEvent("ColorSorter.OnNewBlobsColorMaxBlob4", "OnNewBlobsColorMaxBlob4")

Script.serveEvent("ColorSorter.OnNewResultColor1", "OnNewResultColor1")
Script.serveEvent("ColorSorter.OnNewResultColor2", "OnNewResultColor2")
Script.serveEvent("ColorSorter.OnNewResultColor3", "OnNewResultColor3")
Script.serveEvent("ColorSorter.OnNewResultColor4", "OnNewResultColor4")

Script.serveEvent("ColorSorter.OnNewResultGood", "OnNewResultGood")
Script.serveEvent("ColorSorter.OnNewResultBad", "OnNewResultBad")
Script.serveEvent("ColorSorter.OnNewResult", "OnNewResult")

Script.serveEvent("ColorSorter.OnPipetteActive", "OnPipetteActive")
Script.serveEvent("ColorSorter.OnNewPipetteValue", "OnNewPipetteValue")
Script.serveEvent("ColorSorter.OnNewViewerId", "OnNewViewerId")
Script.serveEvent("ColorSorter.OnProcessingActive", "OnProcessingActive")
Script.serveEvent("ColorSorter.OnNewColorMode", "OnNewColorMode")

Script.serveEvent("ColorSorter.OnNewProcessingTime", "OnNewProcessingTime")
Script.serveEvent("ColorSorter.OnRoiEditorActive", "OnRoiEditorActive")
Script.serveEvent("ColorSorter.OnResultViewerActive", "OnResultViewerActive")
Script.serveEvent("ColorSorter.OnConfigViewerActive", "OnConfigViewerActive")

--****************************************
-- Rules
--****************************************
Script.serveEvent("ColorSorter.OnNewActiveObjectList", "OnNewActiveObjectList")

--****************************************
-- Communication
--****************************************

Script.serveEvent("ColorSorter.OnNewJobSelectedTcpIpIsActive", "OnNewJobSelectedTcpIpIsActive")
Script.serveEvent("ColorSorter.OnNewJobSelectedTcpIpServerAddress", "OnNewJobSelectedTcpIpServerAddress")
Script.serveEvent("ColorSorter.OnNewJobSelectedTcpIpPort", "OnNewJobSelectedTcpIpPort")
Script.serveEvent("ColorSorter.OnNewJobSelectedTcpIpOutputMode", "OnNewJobSelectedTcpIpOutputMode")
Script.serveEvent("ColorSorter.OnNewJobSelectedDigitalOutputIsActive", "OnNewJobSelectedDigitalOutputIsActive")
Script.serveEvent("ColorSorter.OnNewJobSelectedViaEthernet", "OnNewJobSelectedViaEthernet")

--**************************************************************************
--**********************End Global Scope ***********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

--Functions for UI element-binding

--****************************************
-- Camera Setup
--****************************************

local function activateNewCamConfig()
  gCam:stop()
  gCam:setConfig(gConfig)
  gCam:start()
end

function gSetAcquisitionMode(mode)
  if mode == 1 then
    gS3:enable(false)
    gConfig:setAcquisitionMode('SOFTWARE_TRIGGER')
    gCamTriggerFlow:stop()
    Script.notifyEvent("OnFrameRateActive", false)
  elseif mode == 2 then
    gS3:enable(false)
    gConfig:setAcquisitionMode('FIXED_FREQUENCY')
    gConfig:setFrameRate(gJobs[gActualJob]["framerate"])
    gCamTriggerFlow:stop()
    Script.notifyEvent("OnFrameRateActive", true)
  elseif mode == 3 then
    gS3:enable(true)
    gConfig:setAcquisitionMode("HARDWARE_TRIGGER")
    gConfig:setHardwareTriggerMode("LO_HI")
    gCamTriggerFlow:start()
    Script.notifyEvent("OnFrameRateActive", false)
  elseif mode == 4 then
    gS3:enable(false)
    gConfig:setAcquisitionMode('SOFTWARE_TRIGGER')
    gCamTriggerFlow:stop()
    Script.notifyEvent("OnFrameRateActive", false)
  end
end

--@getSwTriggerModeActive():bool
local function getSwTriggerModeActive()
  if gJobs[gActualJob]["triggerMode"] == 1 and gOfflineDemoModeActive == false then
    return true
  else
    return false
  end
end
Script.serveFunction("ColorSorter.getSwTriggerModeActive", getSwTriggerModeActive)

--@getStatusCameraConnected():bool
local function getStatusCameraConnected()
  return gIsConnected
end
Script.serveFunction("ColorSorter.getStatusCameraConnected", getStatusCameraConnected)

--@setCameraIP(address:string):
local function setCameraIP(address)
  gJobs[gActualJob]["camIP"] = address
  gCam:setIPAddress(address)
end
Script.serveFunction("ColorSorter.setCameraIP", setCameraIP)

--@getCameraIP():string
local function getCameraIP()
  return gJobs[gActualJob]["camIP"]
end
Script.serveFunction("ColorSorter.getCameraIP", getCameraIP)

--@getCameraIpWriteable():bool
local function getCameraIpWriteable()
  return false
end
Script.serveFunction("ColorSorter.getCameraIpWriteable", getCameraIpWriteable)

--@getAccessCamConnect():bool
local function getAccessCamConnect()
  return true
end
Script.serveFunction("ColorSorter.getAccessCamConnect", getAccessCamConnect)

--@setCameraSetupViewerStatus(status:bool):
local function setCameraSetupViewerStatus(status)
  gCamSetupViewerActive = status
  if status == false then
    gCamSetupViewer:clear()
    gCamSetupViewer:present()
  end
end
Script.serveFunction("ColorSorter.setCameraSetupViewerStatus", setCameraSetupViewerStatus)

--@getCameraSetupViewerStatus():bool
local function getCameraSetupViewerStatus()
  return gCamSetupViewerActive
end
Script.serveFunction("ColorSorter.getCameraSetupViewerStatus", getCameraSetupViewerStatus)

--@setVisFactor(uiVisFactor:float):
local function setVisFactor(uiVisFactor)
  gJobs[gActualJob]["scaleFactor"] = uiVisFactor
end
Script.serveFunction("ColorSorter.setVisFactor", setVisFactor)

--@getVisFactor():float
local function getVisFactor()
  return gJobs[gActualJob]["scaleFactor"]
end
Script.serveFunction("ColorSorter.getVisFactor", getVisFactor)

--@getTriggerMode():
local function getTriggerMode()
  return gJobs[gActualJob]["triggerMode"]
end
Script.serveFunction("ColorSorter.getTriggerMode", getTriggerMode)

--@setTriggerMode(uiMode:int):
local function setTriggerMode(uiMode)
  gJobs[gActualJob]["triggerMode"] = uiMode
  if gJobs[gActualJob]["triggerMode"] == 1 and gOfflineDemoModeActive == false then
    Script.notifyEvent("OnSwTriggerVisible", true)
  else
    Script.notifyEvent("OnSwTriggerVisible", false)
  end
  gSetAcquisitionMode(gJobs[gActualJob]["triggerMode"])
  activateNewCamConfig()
end
Script.serveFunction("ColorSorter.setTriggerMode", setTriggerMode)

--@setShutterTime(uiShutterTime:int):
local function setShutterTime(uiShutterTime)
  gJobs[gActualJob]["shutterTime"] = uiShutterTime
  gConfig:setShutterTime(gJobs[gActualJob]["shutterTime"])
  activateNewCamConfig()
end
Script.serveFunction("ColorSorter.setShutterTime", setShutterTime)

--@getShutterTime():int
local function getShutterTime()
  return gJobs[gActualJob]["shutterTime"]
end
Script.serveFunction("ColorSorter.getShutterTime", getShutterTime)

--@setFrameRate(uiFrameRate:int):
local function setFrameRate(uiFrameRate)
  gJobs[gActualJob]["framerate"] = uiFrameRate
  gConfig:setFrameRate(gJobs[gActualJob]["framerate"])
  activateNewCamConfig()
end
Script.serveFunction("ColorSorter.setFrameRate", setFrameRate)

--@getFrameRate():int
local function getFrameRate()
  return gJobs[gActualJob]["framerate"]
end
Script.serveFunction("ColorSorter.getFrameRate", getFrameRate)

--@getFrameRateActive():bool
local function getFrameRateActive()
  if gJobs[gActualJob]["triggerMode"] == 2 then
    return true
  else
    return false
  end
end
Script.serveFunction("ColorSorter.getFrameRateActive", getFrameRateActive)

--@setGainFactor(uiGainFactor:float):
local function setGainFactor(uiGainFactor)
  gJobs[gActualJob]["gain"] = uiGainFactor
  gConfig:setGainFactor(gJobs[gActualJob]["gain"])
  activateNewCamConfig()
end
Script.serveFunction("ColorSorter.setGainFactor", setGainFactor)

--@getGainFactor():float
local function getGainFactor()
  return gJobs[gActualJob]["gain"]
end
Script.serveFunction("ColorSorter.getGainFactor", getGainFactor)

--@triggerImage():
local function triggerImage()
  if gJobs[gActualJob]["triggerMode"] == 1 then
    gCam:snapshot()
  end
end
Script.serveFunction("ColorSorter.triggerImage", triggerImage)

--@setOfflineDemoMode(status:bool):
local function setOfflineDemoMode(status)
  gOfflineDemoModeActive = status
  if status == true then
    Image.Provider.Directory.register(gDirectoryProvider, "OnNewImage", gHandleOnNewImageProcessing)
    Script.notifyEvent("OnOfflineDemoModeActive", true)
    gCam:stop()
    gDirectoryProvider:setCycleTime(1000)
    gDirectoryProvider:setPath("resources/SampleImg", "jpg")
    gDirectoryProvider:start(1)
  else
    Image.Provider.Directory.deregister(gDirectoryProvider, "OnNewImage", gHandleOnNewImageProcessing)
    Script.notifyEvent("OnOfflineDemoModeActive", false)
    gCam:start()
  end
end
Script.serveFunction("ColorSorter.setOfflineDemoMode", setOfflineDemoMode)

--@getOfflineDemoMode():bool
local function getOfflineDemoMode()
  return gOfflineDemoModeActive
end
Script.serveFunction("ColorSorter.getOfflineDemoMode", getOfflineDemoMode)

--@saveCameraConfig():
local function saveCameraConfig()
  Parameters.set("ActualJob", gActualJob)
  Parameters.set("Job[" .. tostring(gActualJob-1) .. "]/CameraIP", gJobs[gActualJob]["camIP"])
  Parameters.set("Job[" .. tostring(gActualJob-1) .. "]/TriggerMode", gJobs[gActualJob]["triggerMode"])
  Parameters.set("Job[" .. tostring(gActualJob-1) .. "]/ShutterTime", gJobs[gActualJob]["shutterTime"])
  Parameters.set("Job[" .. tostring(gActualJob-1) .. "]/Framerate", gJobs[gActualJob]["framerate"])
  Parameters.set("Job[" .. tostring(gActualJob-1) .. "]/Gain", gJobs[gActualJob]["gain"]*10)
  Parameters.set("Job[" .. tostring(gActualJob-1) .. "]/Scalefactor", gJobs[gActualJob]["scaleFactor"]*10)

  Parameters.savePermanent()
end
Script.serveFunction("ColorSorter.saveCameraConfig", saveCameraConfig)

--@triggerNewOfflineImage():
local function triggerNewOfflineImage()
  gDirectoryProvider:start(1)
end
Script.serveFunction("ColorSorter.triggerNewOfflineImage", triggerNewOfflineImage)

local function changeOfflineSource()
  if offlineSampleMode == true then
    gDirectoryProvider:setPath("public", "bmp")
    gDirectoryProvider:start(1)
    offlineSampleMode = false
  else
    gDirectoryProvider:setPath("resources/SampleImg", "jpg")
    gDirectoryProvider:start(1)
    offlineSampleMode = true
  end
end
Script.serveFunction("ColorSorter.changeOfflineSource", changeOfflineSource)

local function saveLastImage()
  local freeSpace = File.getDiskFree("/public")
  if freeSpace >10000000 then
    local list = File.list("/public/")
    if list == nil then
      Image.save(gTempImage, "public/Image1.bmp")
    elseif #list <5 then
      Image.save(gTempImage, "public/Image" .. tostring(#list+1) .. ".bmp")
    else
      Image.save(gTempImage, "public/Image" .. tostring(imgCounter) .. ".bmp")
      if imgCounter == 5 then
        imgCounter = 1
      else
        imgCounter = imgCounter + 1
      end
    end
  else
    print("Disk nearly full!")
  end
end
Script.serveFunction("ColorSorter.saveLastImage", saveLastImage)
--****************************************
--Image Processing
--****************************************

function gCheckIfOfflineMode()
  if gOfflineDemoModeActive == true or gJobs[gActualJob]["triggerMode"] ~= 2 then
    gHandleOnNewImageProcessing(gTempImage)
  end
end

--@setForegroundImage(min:int):
local function setForegroundImage(imageNo)
  gJobs[gActualJob]["foregroundImage"] = imageNo
  gCheckIfOfflineMode()
end
Script.serveFunction("ColorSorter.setForegroundImage", setForegroundImage)

--@getForegroundImage():int
local function getForegroundImage()
  return gJobs[gActualJob]["foregroundImage"]
end
Script.serveFunction("ColorSorter.getForegroundImage", getForegroundImage)

--@setBackgroundImage(min:int):
local function setBackgroundImage(imageNo)
  gJobs[gActualJob]["backgroundImage"] = imageNo
  gCheckIfOfflineMode()
end
Script.serveFunction("ColorSorter.setBackgroundImage", setBackgroundImage)

--@getBackgroundImage():int
local function getBackgroundImage()
  return gJobs[gActualJob]["backgroundImage"]
end
Script.serveFunction("ColorSorter.getBackgroundImage", getBackgroundImage)

--@setSaturationThresholdMin(min:int):
local function setSaturationThresholdMin(min)
  gJobs[gActualJob]["minBackground"] = min
  gCheckIfOfflineMode()
end
Script.serveFunction("ColorSorter.setSaturationThresholdMin", setSaturationThresholdMin)

--@getSaturationThresholdMin():int
local function getSaturationThresholdMin()
  return gJobs[gActualJob]["minBackground"]
end
Script.serveFunction("ColorSorter.getSaturationThresholdMin", getSaturationThresholdMin)

--@setSaturationThresholdMax(max:int):
local function setSaturationThresholdMax(max)
  gJobs[gActualJob]["maxBackground"] = max
  gCheckIfOfflineMode()
end
Script.serveFunction("ColorSorter.setSaturationThresholdMax", setSaturationThresholdMax)

--@getSaturationThresholdMax():int
local function getSaturationThresholdMax()
  return gJobs[gActualJob]["maxBackground"]
end
Script.serveFunction("ColorSorter.getSaturationThresholdMax", getSaturationThresholdMax)

--@setForegroundThresholdMin(min:int):
local function setForegroundThresholdMin(min)
  gJobs[gActualJob]["minForeground"] = min
  gCheckIfOfflineMode()
end
Script.serveFunction("ColorSorter.setForegroundThresholdMin", setForegroundThresholdMin)

--@getForegroundThresholdMin():int
local function getForegroundThresholdMin()
  return gJobs[gActualJob]["minForeground"]
end
Script.serveFunction("ColorSorter.getForegroundThresholdMin", getForegroundThresholdMin)

--@setForegroundThresholdMax(max:int):
local function setForegroundThresholdMax(max)
  gJobs[gActualJob]["maxForeground"] = max
  gCheckIfOfflineMode()
end
Script.serveFunction("ColorSorter.setForegroundThresholdMax", setForegroundThresholdMax)

--@getForegroundThresholdMax():int
local function getForegroundThresholdMax()
  return gJobs[gActualJob]["maxForeground"]
end
Script.serveFunction("ColorSorter.getForegroundThresholdMax", getForegroundThresholdMax)

local function getShowAOI()
  return showAOI
end
Script.serveFunction("ColorSorter.getShowAOI", getShowAOI)

local function setShowAOI(status)
  showAOI = status
  if gOfflineDemoModeActive == true or gJobs[gActualJob]["triggerMode"] ~= 2 then
    gHandleOnNewImageProcessing(gTempImage)
  end
end
Script.serveFunction("ColorSorter.setShowAOI", setShowAOI)

local function getImageToShow()
  return imageToShow
end
Script.serveFunction("ColorSorter.getImageToShow", getImageToShow)

local function setImageToShow(imageNo)
  imageToShow = imageNo
  if gOfflineDemoModeActive == true or gJobs[gActualJob]["triggerMode"] ~= 2 then
    gHandleOnNewImageProcessing(gTempImage)
  end
end
Script.serveFunction("ColorSorter.setImageToShow", setImageToShow)

--@getActualColor():int
local function getActualColor()
  return gActualColor
end
Script.serveFunction("ColorSorter.getActualColor", getActualColor)

--@getActualColorActive():bool
local function getActualColorActive()
  return gJobs[gActualJob][gActualColor]["colorActive"]
end
Script.serveFunction("ColorSorter.getActualColorActive", getActualColorActive)

--@setActualColorActive(status:bool):
local function setActualColorActive(status)
  gJobs[gActualJob][gActualColor]["colorActive"] = status
end
Script.serveFunction("ColorSorter.setActualColorActive", setActualColorActive)

--@getColor1Active():bool
local function getColor1Active()
  --return gJobs[gActualJob][1]["colorActive"]
  return gJobs[gActualJob][objectA]["colorActive"]
end
Script.serveFunction("ColorSorter.getColor1Active", getColor1Active)

--@getColor2Active():bool
local function getColor2Active()
  return gJobs[gActualJob][objectB]["colorActive"]
end
Script.serveFunction("ColorSorter.getColor2Active", getColor2Active)

--@getColor3Active():bool
local function getColor3Active()
  return gJobs[gActualJob][objectC]["colorActive"]
end
Script.serveFunction("ColorSorter.getColor3Active", getColor3Active)

--@getColor4Active():bool
local function getColor4Active()
  return gJobs[gActualJob][objectD]["colorActive"]
end
Script.serveFunction("ColorSorter.getColor4Active", getColor4Active)

--@setConfigColor(uiColorValue:int):
local function setConfigColor(uiColorValue)
  gJobs[gActualJob][gActualColor]["value"] = uiColorValue
  gJobs[gActualJob][gActualColor]["regionColor"] = gSelectRegionColor(gJobs[gActualJob][gActualColor]["value"])
  gCheckIfOfflineMode()
end
Script.serveFunction("ColorSorter.setConfigColor", setConfigColor)

--@getConfigColor():int
local function getConfigColor()
  return gJobs[gActualJob][gActualColor]["value"]
end
Script.serveFunction("ColorSorter.getConfigColor", getConfigColor)

--@setConfigTolerance(uiTolerance:int):
local function setConfigTolerance(uiTolerance)
  gJobs[gActualJob][gActualColor]["tolerance"] = uiTolerance
  gCheckIfOfflineMode()
end
Script.serveFunction("ColorSorter.setConfigTolerance", setConfigTolerance)

--@getConfigTolerance():int
local function getConfigTolerance()
  return gJobs[gActualJob][gActualColor]["tolerance"]
end
Script.serveFunction("ColorSorter.getConfigTolerance", getConfigTolerance)

--@setConfigMinBlobSize(size:int):
local function setConfigMinBlobSize(size)
  gJobs[gActualJob][gActualColor]["minBlobSize"] = size
  gCheckIfOfflineMode()
end
Script.serveFunction("ColorSorter.setConfigMinBlobSize", setConfigMinBlobSize)

--@getConfigMinBlobSize():
local function getConfigMinBlobSize()
  return gJobs[gActualJob][gActualColor]["minBlobSize"]
end
Script.serveFunction("ColorSorter.getConfigMinBlobSize", getConfigMinBlobSize)

--@setConfigMaxBlobSize(size:int):
local function setConfigMaxBlobSize(size)
  gJobs[gActualJob][gActualColor]["maxBlobSize"] = size
  gCheckIfOfflineMode()
end
Script.serveFunction("ColorSorter.setConfigMaxBlobSize", setConfigMaxBlobSize)

--@getConfigMaxBlobSize():
local function getConfigMaxBlobSize()
  return gJobs[gActualJob][gActualColor]["maxBlobSize"]
end
Script.serveFunction("ColorSorter.getConfigMaxBlobSize", getConfigMaxBlobSize)


--@getFoundBlobs():string
local function getFoundBlobs()
  return tostring(gJobs[gActualJob][gActualColor]["blobsFound"])
end
Script.serveFunction("ColorSorter.getFoundBlobs", getFoundBlobs)

--@getBlobsColor1():
local function getBlobsColor1()
  --return tostring(gJobs[gActualJob][1]["blobsFound"])
  return tostring(gJobs[gActualJob][objectA]["blobsFound"])
end
Script.serveFunction("ColorSorter.getBlobsColor1", getBlobsColor1)

--@getBlobsColor2():
local function getBlobsColor2()
  return tostring(gJobs[gActualJob][objectB]["blobsFound"])
end
Script.serveFunction("ColorSorter.getBlobsColor2", getBlobsColor2)

--@getBlobsColor3():
local function getBlobsColor3()
  return tostring(gJobs[gActualJob][objectC]["blobsFound"])
end
Script.serveFunction("ColorSorter.getBlobsColor3", getBlobsColor3)

--@getBlobsColor4():
local function getBlobsColor4()
  return tostring(gJobs[gActualJob][objectD]["blobsFound"])
end
Script.serveFunction("ColorSorter.getBlobsColor4", getBlobsColor4)

--@setColorSelectorActive(status:bool):
local function setColorSelectorActive(status)
  gColorSelecterActive = status
  if status == false then
    gConfigViewer:clear()
    gConfigViewer:present()
  end
end
Script.serveFunction("ColorSorter.setColorSelectorActive", setColorSelectorActive)

--@getColorSelectorActive():bool
local function getColorSelectorActive()
  return gColorSelecterActive
end
Script.serveFunction("ColorSorter.getColorSelectorActive", getColorSelectorActive)

--@setResultViewerActive(status:bool):
local function setResultViewerActive(status)
  gResultViewerActive = status
  if status == false then
    gOrgViewer:clear()
    gResViewer:clear()
    gOrgViewer:present()
    gResViewer:present()
  end
end
Script.serveFunction("ColorSorter.setResultViewerActive", setResultViewerActive)

--@getResultViewerActive():bool
local function getResultViewerActive()
  return gResultViewerActive
end
Script.serveFunction("ColorSorter.getResultViewerActive", getResultViewerActive)

--@setResultProcessingActive(status:bool):
local function setResultProcessingActive(status)
  gProcessResults = status
  if status == true then
    gRoiEditorActive = false
    Script.notifyEvent("OnProcessingActive", true)
  else
    Script.notifyEvent("OnProcessingActive", false)
    --Clear Viewer
    gOrgViewer:clear()
    gResViewer:clear()
    gOrgViewer:present()
    gResViewer:present()
  end
end
Script.serveFunction("ColorSorter.setResultProcessingActive", setResultProcessingActive)

--@getResultProcessingActive():bool
local function getResultProcessingActive()
  return gProcessResults
end
Script.serveFunction("ColorSorter.getResultProcessingActive", getResultProcessingActive)

--@setActualColor(color:int):
local function setActualColor(configColor)
  gActualColor = configColor
  gRoiEditorActive = false
  Script.notifyEvent("OnNewJobSelectedActualColorActive", gJobs[gActualJob][gActualColor]["colorActive"])
  Script.notifyEvent("OnNewJobSelectedActualColorRoiActive", gJobs[gActualJob][gActualColor]["roiActive"])
  Script.notifyEvent("OnNewJobSelectedActualColorValue", gJobs[gActualJob][gActualColor]["value"])
  gJobs[gActualJob][gActualColor]["regionColor"] = gSelectRegionColor(gJobs[gActualJob][gActualColor]["value"])
  Script.notifyEvent("OnNewJobSelectedActualColorTolerance", gJobs[gActualJob][gActualColor]["tolerance"])
  Script.notifyEvent("OnNewJobSelectedActualColorMinBlobSize", gJobs[gActualJob][gActualColor]["minBlobSize"])
  Script.notifyEvent("OnNewJobSelectedActualColorMaxBlobSize", gJobs[gActualJob][gActualColor]["maxBlobSize"])
  Script.notifyEvent("OnNewBlobsActualColor", "-")
  Script.notifyEvent("OnNewBlobsActualColorMinBlob", "-")
  Script.notifyEvent("OnNewBlobsActualColorMaxBlob", "-")
  gCheckIfOfflineMode()
end
Script.serveFunction("ColorSorter.setActualColor", setActualColor)

--@getJob():int
local function getJob()
  return gActualJob
end
Script.serveFunction("ColorSorter.getJob", getJob)

--@getJobName():string
local function getJobName()
  return gJobs[gActualJob]["jobName"]
end
Script.serveFunction("ColorSorter.getJobName", getJobName)

--@setJobName(name:string):
local function setJobName(name)
  gJobs[gActualJob]["jobName"] = name
end
Script.serveFunction("ColorSorter.setJobName", setJobName)

--@getBlobMinGood1():int
local function getBlobMinGood1()
  --return gJobs[gActualJob][1]["minGood"]
  return gJobs[gActualJob][objectA]["minGood"]
end
Script.serveFunction("ColorSorter.getBlobMinGood1", getBlobMinGood1)

--@getBlobMinGood2():
local function getBlobMinGood2()
  return gJobs[gActualJob][objectB]["minGood"]
end
Script.serveFunction("ColorSorter.getBlobMinGood2", getBlobMinGood2)

--@getBlobMinGood3():
local function getBlobMinGood3()
  return gJobs[gActualJob][objectC]["minGood"]
end
Script.serveFunction("ColorSorter.getBlobMinGood3", getBlobMinGood3)

--@getBlobMinGood4():
local function getBlobMinGood4()
  return gJobs[gActualJob][objectD]["minGood"]
end
Script.serveFunction("ColorSorter.getBlobMinGood4", getBlobMinGood4)

--@setBlobMinGood1(min:int):
local function setBlobMinGood1(min)
  --gJobs[gActualJob][1]["minGood"] = min
  gJobs[gActualJob][objectA]["minGood"] = min
end
Script.serveFunction("ColorSorter.setBlobMinGood1", setBlobMinGood1)

--@setBlobMinGood2(min:int):
local function setBlobMinGood2(min)
  gJobs[gActualJob][objectB]["minGood"] = min
end
Script.serveFunction("ColorSorter.setBlobMinGood2", setBlobMinGood2)

--@setBlobMinGood3(min:int):
local function setBlobMinGood3(min)
  gJobs[gActualJob][objectC]["minGood"] = min
end
Script.serveFunction("ColorSorter.setBlobMinGood3", setBlobMinGood3)

--@setBlobMinGood4(min:int):
local function setBlobMinGood4(min)
  gJobs[gActualJob][objectD]["minGood"] = min
end
Script.serveFunction("ColorSorter.setBlobMinGood4", setBlobMinGood4)

--@getBlobMaxGood1():int
local function getBlobMaxGood1()
  --return gJobs[gActualJob][1]["maxGood"]
  return gJobs[gActualJob][objectA]["maxGood"]
end
Script.serveFunction("ColorSorter.getBlobMaxGood1", getBlobMaxGood1)

--@getBlobMaxGood2():
local function getBlobMaxGood2()
  return gJobs[gActualJob][objectB]["maxGood"]
end
Script.serveFunction("ColorSorter.getBlobMaxGood2", getBlobMaxGood2)

--@getBlobMaxGood3():
local function getBlobMaxGood3()
  return gJobs[gActualJob][objectC]["maxGood"]
end
Script.serveFunction("ColorSorter.getBlobMaxGood3", getBlobMaxGood3)

--@getBlobMaxGood4():
local function getBlobMaxGood4()
  return gJobs[gActualJob][objectD]["maxGood"]
end
Script.serveFunction("ColorSorter.getBlobMaxGood4", getBlobMaxGood4)

--@setBlobMaxGood1(max:int):
local function setBlobMaxGood1(max)
  --gJobs[gActualJob][1]["maxGood"] = max
  gJobs[gActualJob][objectA]["maxGood"] = max
end
Script.serveFunction("ColorSorter.setBlobMaxGood1", setBlobMaxGood1)

--@setBlobMaxGood2(max:int):
local function setBlobMaxGood2(max)
  gJobs[gActualJob][objectB]["maxGood"] = max
end
Script.serveFunction("ColorSorter.setBlobMaxGood2", setBlobMaxGood2)

--@setBlobMaxGood3(max:int):
local function setBlobMaxGood3(max)
  gJobs[gActualJob][objectC]["maxGood"] = max
end
Script.serveFunction("ColorSorter.setBlobMaxGood3", setBlobMaxGood3)

--@setBlobMaxGood4(max:int):
local function setBlobMaxGood4(max)
  gJobs[gActualJob][objectD]["maxGood"] = max
end
Script.serveFunction("ColorSorter.setBlobMaxGood4", setBlobMaxGood4)

local function getObjectA()
  return objectA
end
Script.serveFunction("ColorSorter.getObjectA", getObjectA)

local function setObjectA(value)
  if value ~= objectB and value ~= objectC and value ~= objectD then
    objectA = value
    Script.notifyEvent("OnNewJobSelectedColor1Active", gJobs[gActualJob][objectA]["colorActive"])
    Script.notifyEvent("OnNewJobSelectedMinBlobGood1", gJobs[gActualJob][objectA]["minGood"])
    Script.notifyEvent("OnNewJobSelectedMaxBlobGood1", gJobs[gActualJob][objectA]["maxGood"])
  else
    Script.notifyEvent("OnNewObjectA", objectA)
  end
end
Script.serveFunction("ColorSorter.setObjectA", setObjectA)

local function getObjectB()
  return objectB
end
Script.serveFunction("ColorSorter.getObjectB", getObjectB)

local function setObjectB(value)
  if value ~= objectA and value ~= objectC and value ~= objectD then
    objectB = value
    Script.notifyEvent("OnNewJobSelectedColor2Active", gJobs[gActualJob][objectB]["colorActive"])
    Script.notifyEvent("OnNewJobSelectedMinBlobGood2", gJobs[gActualJob][objectB]["minGood"])
    Script.notifyEvent("OnNewJobSelectedMaxBlobGood2", gJobs[gActualJob][objectB]["maxGood"])
  else
    Script.notifyEvent("OnNewObjectB", objectB)
  end
end
Script.serveFunction("ColorSorter.setObjectB", setObjectB)

local function getObjectC()
  return objectC
end
Script.serveFunction("ColorSorter.getObjectC", getObjectC)

local function setObjectC(value)
  if value ~= objectA and value ~= objectB and value ~= objectD then
    objectC = value
    Script.notifyEvent("OnNewJobSelectedColor3Active", gJobs[gActualJob][objectC]["colorActive"])
    Script.notifyEvent("OnNewJobSelectedMinBlobGood3", gJobs[gActualJob][objectC]["minGood"])
    Script.notifyEvent("OnNewJobSelectedMaxBlobGood3", gJobs[gActualJob][objectC]["maxGood"])
  else
    Script.notifyEvent("OnNewObjectC", objectC)
  end
end
Script.serveFunction("ColorSorter.setObjectC", setObjectC)

local function getObjectD()
  return objectD
end
Script.serveFunction("ColorSorter.getObjectD", getObjectD)

local function setObjectD(value)
  if value ~= objectA and value ~= objectB and value ~= objectC then
    objectD = value
    Script.notifyEvent("OnNewJobSelectedColor4Active", gJobs[gActualJob][objectD]["colorActive"])
    Script.notifyEvent("OnNewJobSelectedMinBlobGood4", gJobs[gActualJob][objectD]["minGood"])
    Script.notifyEvent("OnNewJobSelectedMaxBlobGood4", gJobs[gActualJob][objectD]["maxGood"])
  else
    Script.notifyEvent("OnNewObjectD", objectD)
  end
end
Script.serveFunction("ColorSorter.setObjectD", setObjectD)

local function checkToNotifyResult(actObject, blobsCnt, blobMin, blobMax, result)
  if actObject == objectA then
    Script.notifyEvent("OnNewBlobsColor1", tostring(blobsCnt))
    Script.notifyEvent("OnNewBlobsColorMinBlob1", tostring(blobMin))
    Script.notifyEvent("OnNewBlobsColorMaxBlob1", tostring(blobMax))
    Script.notifyEvent("OnNewResultColor1", result)
  elseif actObject == objectB then
    Script.notifyEvent("OnNewBlobsColor2", tostring(blobsCnt))
    Script.notifyEvent("OnNewBlobsColorMinBlob2", tostring(blobMin))
    Script.notifyEvent("OnNewBlobsColorMaxBlob2", tostring(blobMax))
    Script.notifyEvent("OnNewResultColor2", result)
  elseif actObject == objectC then
    Script.notifyEvent("OnNewBlobsColor3", tostring(blobsCnt))
    Script.notifyEvent("OnNewBlobsColorMinBlob3", tostring(blobMin))
    Script.notifyEvent("OnNewBlobsColorMaxBlob3", tostring(blobMax))
    Script.notifyEvent("OnNewResultColor3", result)
  elseif actObject == objectD then
    Script.notifyEvent("OnNewBlobsColor4", tostring(blobsCnt))
    Script.notifyEvent("OnNewBlobsColorMinBlob4", tostring(blobMin))
    Script.notifyEvent("OnNewBlobsColorMaxBlob4", tostring(blobMax))
    Script.notifyEvent("OnNewResultColor4", result)
  end
end
Script.serveFunction("ColorSorter.checkToNotifyResult", checkToNotifyResult)

--@setViewerImage(ID:int):
local function setViewerImage(ID)
  gViewerImageID = ID
  Script.notifyEvent("OnNewViewerId", ID)
  gInstalledEditorIconic = nil
  if gJobs[gActualJob]["triggerMode"] ~= 2 or gOfflineDemoModeActive == true then
    gHandleOnNewImageProcessing(gTempImage)
  end
end
Script.serveFunction("ColorSorter.setViewerImage", setViewerImage)

--@getViewerImage():int
local function getViewerImage()
  Script.notifyEvent("OnNewViewerId", gViewerImageID)
  --gInstalledEditorIconic = nil
  return gViewerImageID
end
Script.serveFunction("ColorSorter.getViewerImage", getViewerImage)

local function setColorMode(mode)
  --colorMode = mode
  gJobs[gActualJob][gActualColor]["colorMode"] = mode
  Script.notifyEvent("OnNewColorMode", mode)
  if gOfflineDemoModeActive == true or gJobs[gActualJob]["triggerMode"] ~= 2 then
    gHandleOnNewImageProcessing(gTempImage)
  end
end
Script.serveFunction("ColorSorter.setColorMode", setColorMode)

local function getColorMode()
  Script.notifyEvent("OnNewColorMode", gJobs[gActualJob][gActualColor]["colorMode"])
  return gJobs[gActualJob][gActualColor]["colorMode"]
end
Script.serveFunction("ColorSorter.getColorMode", getColorMode)

--@setRoiEditor(status:bool):
local function setRoiEditor(status)
  gRoiEditorActive = status
  if gRoiEditorActive == true then
    Script.notifyEvent("OnRoiEditorActive", true)
    gInstalledEditorIconic = nil
  else
    Script.notifyEvent("OnRoiEditorActive", false)
  end
  gCheckIfOfflineMode()
end
Script.serveFunction("ColorSorter.setRoiEditor", setRoiEditor)

--@getRoiEditor():bool
local function getRoiEditor()
  if gRoiEditorActive == true then
    Script.notifyEvent("OnRoiEditorActive", true)
  else
    Script.notifyEvent("OnRoiEditorActive", false)
  end
  return gRoiEditorActive
end
Script.serveFunction("ColorSorter.getRoiEditor", getRoiEditor)

--@setActualRoiActive(status:bool):
local function setActualRoiActive(status)
  gJobs[gActualJob][gActualColor]["roiActive"] = status
  Script.notifyEvent("OnNewJobSelectedActualColorRoiActive", status)
  --Script.notifyEvent("OnSetActualRoiActive", status) TODO
  gCheckIfOfflineMode()
end
Script.serveFunction("ColorSorter.setActualRoiActive", setActualRoiActive)

--@getActualRoiActive():bool
local function getActualRoiActive()
  return gJobs[gActualJob][gActualColor]["roiActive"]
end
Script.serveFunction("ColorSorter.getActualRoiActive", getActualRoiActive)

--@setJob(jobNo:int):
local function setJob(jobNo)
  gActualJob = jobNo
  gActualColor = 1
  Script.notifyEvent("OnNewJobSelectedJobName", gJobs[gActualJob]["jobName"])

  Script.notifyEvent("OnNewJobSelectedCamIP", gJobs[gActualJob]["camIP"])
  Script.notifyEvent("OnNewJobSelectedTriggerMode", gJobs[gActualJob]["triggerMode"])
  if gJobs[gActualJob]["triggerMode"] == 1 then
    Script.notifyEvent("OnSwTriggerVisible", true)
    Script.notifyEvent("OnFrameRateActive", false)
  elseif gJobs[gActualJob]["triggerMode"] == 2 then
    Script.notifyEvent("OnFrameRateActive", true)
    Script.notifyEvent("OnSwTriggerVisible", false)
  else
    Script.notifyEvent("OnFrameRateActive", false)
    Script.notifyEvent("OnSwTriggerVisible", false)
  end
  Script.notifyEvent("OnNewJobSelectedShutterTime", gJobs[gActualJob]["shutterTime"])
  Script.notifyEvent("OnNewJobSelectedFramerate", gJobs[gActualJob]["framerate"])
  Script.notifyEvent("OnNewJobSelectedGain", gJobs[gActualJob]["gain"])
  Script.notifyEvent("OnNewJobSelectedScaleFactor", gJobs[gActualJob]["scaleFactor"])

  Script.notifyEvent("OnNewJobSelectedForegroundImage", gJobs[gActualJob]["foregroundImage"])
  Script.notifyEvent("OnNewJobSelectedBackgroundImage", gJobs[gActualJob]["backgroundImage"])

  Script.notifyEvent("OnNewJobSelectedForegroundMin", gJobs[gActualJob]["minForeground"])
  Script.notifyEvent("OnNewJobSelectedForegroundMax", gJobs[gActualJob]["maxForeground"])
  Script.notifyEvent("OnNewJobSelectedBackgroundMin", gJobs[gActualJob]["minBackground"])
  Script.notifyEvent("OnNewJobSelectedBackgroundMax", gJobs[gActualJob]["maxBackground"])
  Script.notifyEvent("OnNewJobSelectedActualColor", gActualColor)
  Script.notifyEvent("OnNewJobSelectedActualColorActive", gJobs[gActualJob][gActualColor]["colorActive"])
  gRoiEditorActive = false
  --Script.notifyEvent("OnNewJobSelectedColor1Active", gJobs[gActualJob][1]["colorActive"])
  Script.notifyEvent("OnNewJobSelectedColor1Active", gJobs[gActualJob][objectA]["colorActive"])
  Script.notifyEvent("OnNewJobSelectedColor2Active", gJobs[gActualJob][objectB]["colorActive"])
  Script.notifyEvent("OnNewJobSelectedColor3Active", gJobs[gActualJob][objectC]["colorActive"])
  Script.notifyEvent("OnNewJobSelectedColor4Active", gJobs[gActualJob][objectD]["colorActive"])
  Script.notifyEvent("OnNewActiveObjectList", ColorSorter.getActiveObjectList())
  Script.notifyEvent("OnNewJobSelectedActualColorValue", gJobs[gActualJob][gActualColor]["value"])
  Script.notifyEvent("OnNewJobSelectedActualColorRoiActive", gJobs[gActualJob][gActualColor]["roiActive"])
  Script.notifyEvent("OnNewJobSelectedActualColorTolerance", gJobs[gActualJob][gActualColor]["tolerance"])
  Script.notifyEvent("OnNewJobSelectedActualColorMinBlobSize", gJobs[gActualJob][gActualColor]["minBlobSize"])
  Script.notifyEvent("OnNewJobSelectedActualColorMaxBlobSize", gJobs[gActualJob][gActualColor]["maxBlobSize"])

  --Script.notifyEvent("OnNewJobSelectedMinBlobGood1", gJobs[gActualJob][1]["minGood"])
  Script.notifyEvent("OnNewJobSelectedMinBlobGood1", gJobs[gActualJob][objectA]["minGood"])
  Script.notifyEvent("OnNewJobSelectedMinBlobGood2", gJobs[gActualJob][objectB]["minGood"])
  Script.notifyEvent("OnNewJobSelectedMinBlobGood3", gJobs[gActualJob][objectC]["minGood"])
  Script.notifyEvent("OnNewJobSelectedMinBlobGood4", gJobs[gActualJob][objectD]["minGood"])

  --Script.notifyEvent("OnNewJobSelectedMaxBlobGood1", gJobs[gActualJob][1]["maxGood"])
  Script.notifyEvent("OnNewJobSelectedMaxBlobGood1", gJobs[gActualJob][objectA]["maxGood"])
  Script.notifyEvent("OnNewJobSelectedMaxBlobGood2", gJobs[gActualJob][objectB]["maxGood"])
  Script.notifyEvent("OnNewJobSelectedMaxBlobGood3", gJobs[gActualJob][objectC]["maxGood"])
  Script.notifyEvent("OnNewJobSelectedMaxBlobGood4", gJobs[gActualJob][objectD]["maxGood"])

  Script.notifyEvent("OnNewJobSelectedTcpIpIsActive", gJobs[gActualJob]["tcpIpActive"])
  Script.notifyEvent("OnNewJobSelectedTcpIpServerAddress", gJobs[gActualJob]["tcpIpServerAddress"])
  Script.notifyEvent("OnNewJobSelectedTcpIpPort", gJobs[gActualJob]["tcpIpPort"])
  Script.notifyEvent("OnNewJobSelectedTcpIpOutputMode", gJobs[gActualJob]["tcpIpOutMode"])
  Script.notifyEvent("OnNewJobSelectedDigitalOutputIsActive", gJobs[gActualJob]["digOutActive"])
  gS4:enable(gJobs[gActualJob]["digOutActive"])

  local tic = DateTime.getTimestamp()

  ColorSorter.setOfflineDemoMode(false)
  ColorSorter.setCameraConfig()
  ColorSorter.createTCPsocket(gJobs[gActualJob]["tcpIpActive"])

  local toc = DateTime.getTimestamp()
  print("Change job time = " .. tostring(toc-tic))
end
Script.serveFunction("ColorSorter.setJob", setJob)

--@saveJobConfiguration():
local function saveJobConfiguration()
  Parameters.set("ActualJob", gActualJob)
  for i = 1, 5 do
    Parameters.set("Job[" .. tostring(i-1) .. "]/JobName", gJobs[i]["jobName"])
    
    Parameters.set("Job[" .. tostring(i-1) .. "]/ForegroundImage", gJobs[i]["foregroundImage"])
    Parameters.set("Job[" .. tostring(i-1) .. "]/BackgroundImage", gJobs[i]["backgroundImage"])
    Parameters.set("Job[" .. tostring(i-1) .. "]/ForegroundMin", gJobs[i]["minForeground"])
    Parameters.set("Job[" .. tostring(i-1) .. "]/ForegroundMax", gJobs[i]["maxForeground"])
    Parameters.set("Job[" .. tostring(i-1) .. "]/BackgroundMin", gJobs[i]["minBackground"])
    Parameters.set("Job[" .. tostring(i-1) .. "]/BackgroundMax", gJobs[i]["maxBackground"])
    for j = 1, 12 do
      Parameters.set("Job[" .. tostring(i-1) .. "]/Object[" .. tostring(j-1) .. "]/ColorActive", gJobs[i][j]["colorActive"])
      Parameters.set("Job[" .. tostring(i-1) .. "]/Object[" .. tostring(j-1) .. "]/ColorMode", gJobs[i][j]["colorMode"])
      Parameters.set("Job[" .. tostring(i-1) .. "]/Object[" .. tostring(j-1) .. "]/ColorValue", gJobs[i][j]["value"])
      Parameters.set("Job[" .. tostring(i-1) .. "]/Object[" .. tostring(j-1) .. "]/RegionColorValue", gJobs[i][j]["regionColor"])
      Parameters.set("Job[" .. tostring(i-1) .. "]/Object[" .. tostring(j-1) .. "]/ColorTolerance", gJobs[i][j]["tolerance"])
      Parameters.set("Job[" .. tostring(i-1) .. "]/Object[" .. tostring(j-1) .. "]/MinBlobSize", gJobs[i][j]["minBlobSize"])
      Parameters.set("Job[" .. tostring(i-1) .. "]/Object[" .. tostring(j-1) .. "]/MaxBlobSize", gJobs[i][j]["maxBlobSize"])
      Parameters.set("Job[" .. tostring(i-1) .. "]/Object[" .. tostring(j-1) .. "]/MinGood", gJobs[i][j]["minGood"])
      Parameters.set("Job[" .. tostring(i-1) .. "]/Object[" .. tostring(j-1) .. "]/MaxGood", gJobs[i][j]["maxGood"])

      Parameters.set("Job[" .. tostring(i-1) .. "]/Object[" .. tostring(j-1) .. "]/ROI_Active", gJobs[i][j]["roiActive"])
      local tempCenterPoint, width, height = Shape.getRectangleParameters(gJobs[i][j]["ROI"])
      local x, y = Point.getXY(tempCenterPoint)
      Parameters.set("Job[" .. tostring(i-1) .. "]/Object[" .. tostring(j-1) .. "]/ROI_CenterX", x)
      Parameters.set("Job[" .. tostring(i-1) .. "]/Object[" .. tostring(j-1) .. "]/ROI_CenterY", y)
      Parameters.set("Job[" .. tostring(i-1) .. "]/Object[" .. tostring(j-1) .. "]/ROI_Width", width)
      Parameters.set("Job[" .. tostring(i-1) .. "]/Object[" .. tostring(j-1) .. "]/ROI_Height", height)
      
    end
  end
  Parameters.savePermanent()
  print("Saved Job!")
end
Script.serveFunction("ColorSorter.saveJobConfiguration", saveJobConfiguration)

--****************************************
--Rules
--****************************************
-- Building JSON string, parsing the lua table
--@gBuildJSON(data:table)
local function gBuildJSON(data)
  local tableData = '['
  local row = {}
  for i, v in ipairs(data) do
    if i >= 2 then
      tableData = tableData .. ','
    end
    row[i] = '{"idValue":"' .. v.idValue .. '"}'
    tableData = tableData .. row[i]
  end
  local tableString = tableData .. ']'
  return tableString
end

local function getActiveObjectList()
  local activeObjectList = {}
  for i=1, #gJobs[gActualJob] do
    if gJobs[gActualJob][i]["colorActive"] == true then
      local row = {idValue = 'Object ' .. tostring(i)}
      table.insert(activeObjectList, row)
    end
  end
  local endResult = gBuildJSON(activeObjectList)
  return endResult
end
Script.serveFunction("ColorSorter.getActiveObjectList", getActiveObjectList)
--****************************************
-- Communication
--****************************************

--@getDigitalOutActive():
local function getDigitalOutActive()
  return gJobs[gActualJob]["digOutActive"]
end
Script.serveFunction("ColorSorter.getDigitalOutActive", getDigitalOutActive)

--@setDigitalOutActive(status:bool):
local function setDigitalOutActive(status)
  gJobs[gActualJob]["digOutActive"] = status
  gS4:enable(status)
end
Script.serveFunction("ColorSorter.setDigitalOutActive", setDigitalOutActive)

--@getSocketStatus():bool
local function getSocketStatus()
  return gTcpClient:isConnected()
end
Script.serveFunction("ColorSorter.getSocketStatus", getSocketStatus)

--@saveCommunicationConfig():
local function saveCommunicationConfig()
  Parameters.set("Job[" .. tostring(gActualJob-1) .. "]/TcpIpSetActive", gJobs[gActualJob]["tcpIpActive"])
  Parameters.set("Job[" .. tostring(gActualJob-1) .. "]/TcpIpServerIpAddress", gJobs[gActualJob]["tcpIpServerAddress"])
  Parameters.set("Job[" .. tostring(gActualJob-1) .. "]/TcpIpPort", gJobs[gActualJob]["tcpIpPort"])
  Parameters.set("Job[" .. tostring(gActualJob-1) .. "]/TcpIpOutputMode", gJobs[gActualJob]["tcpIpOutMode"])
  Parameters.set("Job[" .. tostring(gActualJob-1) .. "]/DigitalOutputActive", gJobs[gActualJob]["digOutActive"])
  Parameters.savePermanent()
end
Script.serveFunction("ColorSorter.saveCommunicationConfig", saveCommunicationConfig)

--@getTcpIpIsActive():bool
local function getTcpIpIsActive()
  return gJobs[gActualJob]["tcpIpActive"]
end
Script.serveFunction("ColorSorter.getTcpIpIsActive", getTcpIpIsActive)

--@setTcpIpIsActive(status:bool):
local function setTcpIpIsActive(status)
  gJobs[gActualJob]["tcpIpActive"] = status
  if status == true then
    ColorSorter.createTCPsocket(true)
  else
    ColorSorter.createTCPsocket(false)
  end
end
Script.serveFunction("ColorSorter.setTcpIpIsActive", setTcpIpIsActive)

--@getTcpIpPort():int
local function getTcpIpPort()
  return gJobs[gActualJob]["tcpIpPort"]
end
Script.serveFunction("ColorSorter.getTcpIpPort", getTcpIpPort)

--@setTcpIpPort(port:int):
local function setTcpIpPort(port)
  gJobs[gActualJob]["tcpIpPort"] = port
end
Script.serveFunction("ColorSorter.setTcpIpPort", setTcpIpPort)

--@getTcpIpServerAddress():string
local function getTcpIpServerAddress()
  return gJobs[gActualJob]["tcpIpServerAddress"]
end
Script.serveFunction("ColorSorter.getTcpIpServerAddress", getTcpIpServerAddress)

--@setTcpIpServerAddress(address:string):
local function setTcpIpServerAddress(address)
  gJobs[gActualJob]["tcpIpServerAddress"] = address
end
Script.serveFunction("ColorSorter.setTcpIpServerAddress", setTcpIpServerAddress)

--@getTcpIpOutputMode():int
local function getTcpIpOutputMode()
  return gJobs[gActualJob]["tcpIpOutMode"]
end
Script.serveFunction("ColorSorter.getTcpIpOutputMode", getTcpIpOutputMode)

--@setTcpIpOutputMode(mode:int):
local function setTcpIpOutputMode(mode)
  gJobs[gActualJob]["tcpIpOutMode"] = mode
end
Script.serveFunction("ColorSorter.setTcpIpOutputMode", setTcpIpOutputMode)

--**************************************************************************
--**********************End Function Scope *********************************
--**************************************************************************
