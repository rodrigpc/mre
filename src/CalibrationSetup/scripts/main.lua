--[[----------------------------------------------------------------------------
  
  Application Name: CalibrationSetup
                                                                                             
  Description:                                                                   
  Camera calibration for SIM4000
                                                                              
  This App enables a SIM4000 user to calibrate connected camera setup intrinsically 
  and extrinsically. It allows capturing, recording, and the selection of camera 
  images for the intrinsic and extrinsic calibration using a checkerboard pattern. 
  The parameterization page allows the configuration of camera and calibration 
  parameters. The operation and configuration can be done fully through the included 
  user interface which can easily be accessed using a browser and the IP of the 
  connected device. If no connection to the chosen camera can be made, the app
  will fall back to read images from directory.
                                               
------------------------------------------------------------------------------]]
--Start of Global Scope--------------------------------------------------------- 

Script.serveEvent("CalibrationSetup.OnImageRecordingStopped", "OnImageRecordingStopped")
Script.serveEvent("CalibrationSetup.OnImageRecordingReset", "OnImageRecordingReset")
Script.serveEvent("CalibrationSetup.OnChangeImageProvider", "OnChangeImageProvider")
Script.register("CalibrationSetup.OnImageRecordingStopped", "stopImageProvider")
Script.register("CalibrationSetup.OnImageRecordingReset", "resetImageProvider")
Script.register("CalibrationSetup.OnChangeImageProvider", "changeImageProvider")

require "Parameterization"
require "IntrinsicCalibration"
require "ExtrinsicCalibration"


local bImageProviderStarted = false
local intrinsicCameraModel = nil
local bUseCam = false
local cam = nil
local handle = nil
local currentCameraType = Parameters.get("CameraType")
local currentCameraIP = Parameters.get("IPAddress")
local currentShutterTime = Parameters.get("ShutterTime")
local currentAcquisitionMode = Parameters.get("AcquisitionMode")
local currentFrameRate = Parameters.get("FrameRate")
local currentPixelClock = Parameters.get("CustomPixelClock")
local currentGainFactor = Parameters.get("GainFactor")


--End of Global Scope----------------------------------------------------------- 


--Start of Function and Event Scope---------------------------------------------

-----------------------------------------------------------------------------------------------
-- Function runImageDirectoryProvider
-- Creates and starts an image provider on the resources directory
-----------------------------------------------------------------------------------------------
function runImageDirectoryProvider()
  handle = nil
  collectgarbage()
  bUseCam = false
  playPath = "resources/SampleImages/Intrinsic"
  -- Create an ImageDirectoryProvider 
  handle = Image.Provider.Directory.create()
  -- Define the path from which the provider gets images
  Image.Provider.Directory.setPath(handle, playPath)
  -- Set the a cycle time of 500ms 
  Image.Provider.Directory.setCycleTime(handle, 500)
  -- Register the callback function
  Image.Provider.Directory.register(handle, "OnNewImage", "handleNewImage")
  -- start the provider 
  startImageProvider()
end

-----------------------------------------------------------------------------------------------
-- Function runRemoteCameraProvider
-- Creates and starts a camera provider for devices connected the the SIM4000
-----------------------------------------------------------------------------------------------
function runRemoteCameraProvider(camType, camIP)
  cam = nil
  collectgarbage()
  -- Get camera specific configuration
  local config = getCameraConfiguration(camType)
  local connected = false
  if (config ~= nil) then
    -- Create a remote Camera
    cam = Image.Provider.RemoteCamera.create()
    Image.Provider.RemoteCamera.setType(cam, camType) 
    Image.Provider.RemoteCamera.setIPAddress(cam, camIP)
    Image.Provider.RemoteCamera.setConfig(cam, config)
    Image.Provider.RemoteCamera.register(cam, "OnNewImage", "handleNewImage")
    -- Connect the camera
          setConsoleMessage("Connect to camera "..camType)
    connected = Image.Provider.RemoteCamera.connect(cam)
    if connected then
      bUseCam = true
      setConsoleMessage("Successfully connected to camera")
      verifyCameraConnectionParameters(camType)
      startImageProvider()
    else
      setConsoleMessage("Error: Could not connect to camera")
    end
  end 
  return connected
end  

-----------------------------------------------------------------------------------------------
-- Function getCameraConfiguration(camType)
-- Create and parameterize camera configuration handle for cameras supported by the engine
-- Feasible values for the argument camType are {"I2D", "GigEVision", "IDS-uEye", "V3SXX0"}
-- Returns a camera configuration handle
-- To be extended
-----------------------------------------------------------------------------------------------
function getCameraConfiguration(camType)
  local cameraConfiguration = nil
  if (camType == "I2DCAM") then
    cameraConfiguration = Image.Provider.RemoteCamera.I2DConfig.create()
    if (currentShutterTime == 'AUTO') then
      Image.Provider.RemoteCamera.I2DConfig.setAutoShutterEnabled(cameraConfiguration, true)
    else
      Image.Provider.RemoteCamera.I2DConfig.setShutterTime(cameraConfiguration, tonumber(currentShutterTime))
    end
    if (currentFrameRate == 'AUTO') then
      Image.Provider.RemoteCamera.I2DConfig.setPixelClock(cameraConfiguration, currentPixelClock)
      Image.Provider.RemoteCamera.I2DConfig.setAutoFramerateEnabled(cameraConfiguration, true)
    else
      Image.Provider.RemoteCamera.I2DConfig.setPixelClock(cameraConfiguration, currentPixelClock)
      Image.Provider.RemoteCamera.I2DConfig.setFrameRate(cameraConfiguration, tonumber(currentFrameRate))
    end
    if (currentGainFactor == 'AUTO') then
      Image.Provider.RemoteCamera.I2DConfig.setAutoGainEnabled(cameraConfiguration, true)
    else
      Image.Provider.RemoteCamera.I2DConfig.setGainFactor(cameraConfiguration, tonumber(currentGainFactor))
    end
    Image.Provider.RemoteCamera.I2DConfig.setAcquisitionMode(cameraConfiguration, currentAcquisitionMode)
  elseif (camType == "GigEVision") then
    cameraConfiguration = Image.Provider.RemoteCamera.GigEVisionConfig.create()
    if (currentShutterTime == 'AUTO') then
      setConsoleMessage("Error: Camera type ".. camType .. " does not support AUTO shutter time")  
    else
      Image.Provider.RemoteCamera.GigEVisionConfig.setShutterTime(cameraConfiguration, tonumber(currentShutterTime))
    end
    if (currentFrameRate == 'AUTO') then
      setConsoleMessage("Error: Camera type ".. camType .. " does not support AUTO frame rate")  
    else
      Image.Provider.RemoteCamera.GigEVisionConfig.setFrameRate(cameraConfiguration, tonumber(currentFrameRate))
    end
    if (currentGainFactor == 'AUTO') then
      setConsoleMessage("Error: Camera type ".. camType .. " does not support AUTO gain")  
    else
      Image.Provider.RemoteCamera.GigEVisionConfig.setGainFactor(cameraConfiguration, tonumber(currentGainFactor))
    end
  elseif (camType == "IDS-uEye") then
    cameraConfiguration = Image.Provider.RemoteCamera.IDSuEyeConfig.create()
    if (currentShutterTime == 'AUTO') then
      Image.Provider.RemoteCamera.IDSuEyeConfig.setAutoShutterEnabled(cameraConfiguration, true)
    else
      Image.Provider.RemoteCamera.IDSuEyeConfig.setShutterTime(cameraConfiguration, tonumber(currentShutterTime))
    end
    if (currentFrameRate == 'AUTO') then
      Image.Provider.RemoteCamera.IDSuEyeConfig.setPixelClock(cameraConfiguration, currentPixelClock)
      Image.Provider.RemoteCamera.IDSuEyeConfig.setAutoFramerateEnabled(cameraConfiguration, true)
    else
      Image.Provider.RemoteCamera.IDSuEyeConfig.setPixelClock(cameraConfiguration, currentPixelClock)
      Image.Provider.RemoteCamera.IDSuEyeConfig.setFrameRate(cameraConfiguration, tonumber(currentFrameRate))
    end
    if (currentGainFactor == 'AUTO') then
      Image.Provider.RemoteCamera.IDSuEyeConfig.setAutoGainEnabled(cameraConfiguration, true)
    else
      Image.Provider.RemoteCamera.IDSuEyeConfig.setGainFactor(cameraConfiguration, tonumber(currentGainFactor))
    end
    Image.Provider.RemoteCamera.IDSuEyeConfig.setAcquisitionMode(cameraConfiguration, currentAcquisitionMode)
  elseif (camType == "V3SXX0") then
    cameraConfiguration = Image.Provider.RemoteCamera.V3SXX0Config.create()
  else
    setConsoleMessage("Error: Camera type ".. camType .. " not supported")  
  end
  return cameraConfiguration
end

function verifyCameraConnectionParameters(camType)
  local connectCamConfig = Image.Provider.RemoteCamera.getConfig(cam)
  if (camType == "I2DCAM") then
    local newfps = Image.Provider.RemoteCamera.I2DConfig.getFrameRate(connectCamConfig)
    if (math.floor(newfps) ~= tonumber(currentFrameRate)) then
        Parameters.set("FrameRate",tostring(math.floor(newfps)))
        Parameters.apply()
        setConsoleMessage("Could not set frame rate to " .. tonumber(currentFrameRate) ..". New frame rate is " .. newfps .. " Hz")
        setConsoleMessage("For a higher frame rate, increase PixelClock parameter")   
    end
  elseif (camType == "IDS-uEye") then
    local newfps = Image.Provider.RemoteCamera.IDSuEyeConfig.getFrameRate(connectCamConfig)
    if (math.floor(newfps) ~= tonumber(currentFrameRate)) then
        Parameters.set("FrameRate",tostring(math.floor(newfps)))
        Parameters.apply()
        setConsoleMessage("Could not set frame rate to " .. tonumber(currentFrameRate) ..". New frame rate is " .. newfps .. " Hz")
        setConsoleMessage("For a higher frame rate, increase PixelClock parameter")   
    end
  end
end

-----------------------------------------------------------------------------------------------
-- Function 
-- Definition of the callback function which is registered at the provider
-- img contains the image itself 
-- sensorData contains additional information about the image
-----------------------------------------------------------------------------------------------
function handleNewImage(img, sensorData)
  -- get the timestamp from the metadata
  local timeStamp = SensorData.getTimestamp(sensorData)
  -- get the filename from the metadata
  local origin = SensorData.getOrigin(sensorData)
  -- get the dimensions from the image
  local width, height = Image.getSize(img)
  -- set image for calibration image view
  setNewImage(img)
end

-----------------------------------------------------------------------------------------------
-- Function startImageProvider
-- Starts the image provider either from directory or remote camera depending on the bUseCam flag
-- which is set either in runImageDirectoryProvider or runRemoteCameraProvider
-----------------------------------------------------------------------------------------------
function startImageProvider()
  local success = false
  if (bUseCam) then
    success = Image.Provider.RemoteCamera.start(cam)
    setConsoleMessage("Starting image provider on camera with type "..  currentCameraType .." and IP address ".. currentCameraIP)
  else
    success = Image.Provider.Directory.start(handle)
    setConsoleMessage("Starting image provider on directory")
  end
  if success then
    setConsoleMessage("ImageProvider successfully started")
  else
    setConsoleMessage("ImageProvider could not be started")
  end
end

-----------------------------------------------------------------------------------------------
-- Function stopImageProvider
-- Stop the image provider either from directory or remote camera depending on the bUseCam flag
-- which is set either in runImageDirectoryProvider or runRemoteCameraProvider
-----------------------------------------------------------------------------------------------
function stopImageProvider()
  local success = false
  if (cam ~= nil or handle ~= nil) then
    if (bUseCam) then
      success = Image.Provider.RemoteCamera.stop(cam)
      setConsoleMessage("Stopping image provider on camera with type ".. currentCameraType .." and IP address ".. currentCameraIP)
    else
      success = Image.Provider.Directory.stop(handle)
      setConsoleMessage("Stopping image provider on directory")
    end
    if success then
      setConsoleMessage("ImageProvider successfully stopped")
    else
      setConsoleMessage("ImageProvider could not be stopped")
    end
  end
end

-----------------------------------------------------------------------------------------------
-- Function resetImageProvider
-- Resets the image provider by stopping and starting it
-----------------------------------------------------------------------------------------------
function resetImageProvider()
  stopImageProvider()
  startImageProvider()
end

-----------------------------------------------------------------------------------------------
-- Function changeImageProvider
-- Allows user to change the camera type and, thus, the image provider during run time by changing
-- the parameters ("CameraType", "IPAddress")
-----------------------------------------------------------------------------------------------
function changeImageProvider()
  stopImageProvider()
  currentCameraType = Parameters.get("CameraType")
  currentCameraIP = Parameters.get("IPAddress")
  currentShutterTime = Parameters.get("ShutterTime")
  currentAcquisitionMode = Parameters.get("AcquisitionMode")
  currentFrameRate = Parameters.get("FrameRate")
  currentPixelClock = Parameters.get("CustomPixelClock")
  currentGainFactor = Parameters.get("GainFactor")
  local camConnected = false
  if (currentCameraType == "Directory") then
    runImageDirectoryProvider()
  elseif (currentCameraType == "I2D") then
    camConnected = runRemoteCameraProvider("I2DCAM", currentCameraIP)
  elseif (currentCameraType == "GigEVision") then
    camConnected = runRemoteCameraProvider("GIGE_VISIONCAM", currentCameraIP)
  elseif (currentCameraType == "IDS-uEye") then
    camConnected = runRemoteCameraProvider("IDS_UEYE_CAM", currentCameraIP)
  elseif (currentCameraType == "V2D") then
    camConnected = runRemoteCameraProvider("V2DCAM", currentCameraIP)
  elseif (currentCameraType == "V3SXX0") then
    camConnected = runRemoteCameraProvider("VISTOR_T", currentCameraIP)
  end
  if (not camConnected and currentCameraType ~= "Directory") then
    setConsoleMessage("Switching to image provider on directory due to camera connection failure")
    setDefaultParameters()
  end
end

-----------------------------------------------------------------------------------------------
-- Function setConsoleMessage
-- Writes info and error messages into the consoles of the intrinsic calibration page, the
-- the extrinsic calibration page, and the parameterization page
-----------------------------------------------------------------------------------------------
function setConsoleMessage(message)
  setIntrinsicConsoleMessage(message)
  setExtrinsicConsoleMessage(message)
  setParameterizationConsoleMessage(message)
end

--@handleOnStarted()
function handleOnStarted()
  initIntrinsicCalibration()
  initExtrinsicCalibration()
  changeImageProvider()
end
local regSuccess = Script.register("Engine.OnStarted", handleOnStarted)


-----------------------------------------------------------------------------------------------
-- Function setNewImage
-- Image view shows the argument image which is set by main.lua in order to show the currently
-- capture image. Image is resized to 640x480
-----------------------------------------------------------------------------------------------
function setNewImage(image)
  currentImage = Image.clone(image)
  setIntrinsicNewImage()
  setExtrinsicNewImage(currentCameraType)
end
--End of Function and Event Scope-----------------------------------------------

