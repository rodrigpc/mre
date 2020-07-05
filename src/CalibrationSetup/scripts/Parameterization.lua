Script.serveEvent("CalibrationSetup.OnNewSquareWidth", "OnNewSquareWidth", "float")
Script.serveEvent("CalibrationSetup.OnNewSquareHeight", "OnNewSquareHeight", "float")
Script.serveEvent("CalibrationSetup.OnNewNumSquaresPerRow", "OnNewNumSquaresPerRow", "int")
Script.serveEvent("CalibrationSetup.OnNewNumSquaresPerColumn", "OnNewNumSquaresPerColumn", "int")
Script.serveEvent("CalibrationSetup.OnNewIPAddress", "OnNewIPAddress", "string")
Script.serveEvent("CalibrationSetup.OnNewCameraType", "OnNewCameraType", "string")
Script.serveEvent("CalibrationSetup.OnNewParameterizationConsoleMessage", "OnNewParameterizationConsoleMessage", "string")
Script.serveEvent("CalibrationSetup.OnNewCalibrationPatternLink", "OnNewCalibrationPatternLink", "string")
Script.serveFunction("CalibrationSetup.setDefaultParameters", "setDefaultParameters")
Script.serveFunction("CalibrationSetup.setParameters", "setParameters")

-----------------------------------------------------------------------------------------------
-- Start of global scope for the script Parameterization.lua
-- Includes the definition of default parameters.
-----------------------------------------------------------------------------------------------
local maxScrollBackLines = 10
local parameterizationConsoleMessages = {}

local currentParamCameraType = Parameters.get("CameraType")
local currentParamCameraIP = Parameters.get("IPAddress")
local currentParamShutterTime = Parameters.get("ShutterTime")
local currentParamAcquisitionMode = Parameters.get("AcquisitionMode")
local currentParamFrameRate = Parameters.get("FrameRate")
local currentParamPixelClock = Parameters.get("CustomPixelClock")
local currentParamGainFactor = Parameters.get("GainFactor")
local defaultCheckerBoardDimensions = {50, 50, 6, 6}
local defaultIP = "192.168.0.1"
local defaultCameraType = "Directory"
local defaultShutterTime = 2500
local defaultAcqusitionMode = "FIXED_FREQUENCY"
local defaultFrameRate = 25
local defaultPixelClock = 72
local defaultGainFactor = "AUTO"
--local defaultExtrinsicEstimationMethod = "PLAIN"
local defaultCheckerBoardParameters = {}
defaultCheckerBoardParameters["PLAIN"] = {16.0, 16.0, 17, 12}
defaultCheckerBoardParameters["MATRIX_CODE"] = {19.0, 19.0, 13, 9}
defaultCheckerBoardParameters["THREE_DOT"] = {24.0, 24.0, 11, 7}
defaultCheckerBoardParameters["COORDINATE_CODE"] = {24.0, 24.0, 11, 7}

local calibrationPatternLinks = {plain="https://supportportal.sick.com/media/editor/rydsda/2017/01/10/a4_plain_24045um.png",
                                  matrix_code="https://supportportal.sick.com/media/editor/rydsda/2017/01/10/a4_matrix_code_24045um.png",
                                  three_dot="https://supportportal.sick.com/media/editor/rydsda/2017/01/10/a4_three_dot_24045um.png",
                                  coordinate_code="https://supportportal.sick.com/media/editor/rydsda/2017/01/10/a4_coordinate_code_24045um.png"}
local calbPatternViewer = View.create()
calbPatternViewer:setID("calibrationPatternVisualization")

--@handleOnParametersChanged()
function handleOnParametersChanged()
  currentParamCameraType = Parameters.get("CameraType")
  local estimationMethod = Parameters.get("ExtrinsicEstimationMethod")
  local extFilename = ".png"
  local filename = "resources/CalibrationPatterns/"
  local calibPatternImage = Image.load(filename .. estimationMethod .. extFilename) 
  View.view(calbPatternViewer, calibPatternImage)
  if (estimationMethod ==  "MATRIX_CODE") then
    Script.notifyEvent("OnNewCalibrationPatternLink", calibrationPatternLinks.matrix_code)
  elseif (estimationMethod ==  "THREE_DOT") then
    Script.notifyEvent("OnNewCalibrationPatternLink", calibrationPatternLinks.three_dot)
  elseif (estimationMethod ==  "COORDINATE_CODE") then
    Script.notifyEvent("OnNewCalibrationPatternLink", calibrationPatternLinks.coordinate_code)
  else
    Script.notifyEvent("OnNewCalibrationPatternLink", calibrationPatternLinks.plain)
  end
  setExtrinsicNewImage(currentParamCameraType)
end


local regSuccess = Script.register("Parameters.OnParametersChanged", handleOnParametersChanged)


-----------------------------------------------------------------------------------------------
-- Function setDefaultParameters
-- Sets app parameters to default values
-----------------------------------------------------------------------------------------------
function setDefaultParameters()
  Parameters.set("SquareWidth",defaultCheckerBoardDimensions[1])
  Parameters.set("SquareHeight",defaultCheckerBoardDimensions[2])
  Parameters.set("NumSquaresRow",defaultCheckerBoardDimensions[3])
  Parameters.set("NumSquaresColumn",defaultCheckerBoardDimensions[4])
  Parameters.set("IPAddress",defaultIP)
  Parameters.set("CameraType",defaultCameraType)
  Parameters.set("ShutterTime",defaultShutterTime)
  Parameters.set("AcquisitionMode",defaultAcqusitionMode)
  Parameters.set("FrameRate",defaultFrameRate)
  Parameters.set("CustomPixelClock",defaultPixelClock)
  Parameters.set("GainFactor",defaultGainFactor)
  local estimationMethod = Parameters.get("ExtrinsicEstimationMethod")
  Parameters.set("SquareWidth",defaultCheckerBoardParameters[estimationMethod][1])
  Parameters.set("SquareHeight",defaultCheckerBoardParameters[estimationMethod][2])
  Parameters.set("NumSquaresRow",defaultCheckerBoardParameters[estimationMethod][3])
  Parameters.set("NumSquaresColumn",defaultCheckerBoardParameters[estimationMethod][4])
  setParameters()
end

-----------------------------------------------------------------------------------------------
-- Function setParameters
-- Current parameters are used to set global app variables
-----------------------------------------------------------------------------------------------
function setParameters()
  Parameters.apply()
  Parameters.savePermanent()
  local changeProvider = false
  if (currentParamCameraType ~= Parameters.get("CameraType") or
      currentParamCameraIP ~= Parameters.get("IPAddress") or
      currentParamShutterTime ~= Parameters.get("ShutterTime") or
      currentParamAcquisitionMode ~= Parameters.get("AcquisitionMode") or
      currentParamFrameRate ~= Parameters.get("FrameRate") or
      currentParamPixelClock ~= Parameters.get("CustomPixelClock") or
      currentParamGainFactor ~= Parameters.get("GainFactor")) then
      currentParamShutterTime = Parameters.get("ShutterTime")
      currentParamAcquisitionMode = Parameters.get("AcquisitionMode")
      currentParamFrameRate = Parameters.get("FrameRate")
      currentParamPixelClock = Parameters.get("PixelClock")
      currentParamGainFactor = Parameters.get("GainFactor")
      currentParamCameraType = Parameters.get("CameraType")
      currentParamCameraIP = Parameters.get("IPAddress")
      changeProvider = true
  end
  if (changeProvider) then
    changeImageProvider()
  end
end

-----------------------------------------------------------------------------------------------
-- Function setParameterizationConsoleMessage
-- Adds the argument message (newest message element) to the parameterizationConsoleMessages for
-- displaying info, status, and error messages relevant to the parameterzation of the application.
-- Not more than maxScrollBackLines messages are stored. Older messages are deleted
-----------------------------------------------------------------------------------------------
function setParameterizationConsoleMessage(message)
  local nScrollBackLines = table.maxn(parameterizationConsoleMessages)
  if (nScrollBackLines < maxScrollBackLines) then
    nScrollBackLines = nScrollBackLines+1
    parameterizationConsoleMessages[nScrollBackLines] = message
  else
    for i = 1, nScrollBackLines-1 do
      parameterizationConsoleMessages[i] = parameterizationConsoleMessages[i+1]
    end
    parameterizationConsoleMessages[nScrollBackLines] = message
  end
  local consoleString = getParameterizationConsoleMessage()
  Script.notifyEvent("OnNewParameterizationConsoleMessage", consoleString)
end

-----------------------------------------------------------------------------------------------
-- Function getParameterizationConsoleMessage
-- Converts parameterizationConsoleMessages to a console string for static text control in the 
-- paramterization page
-----------------------------------------------------------------------------------------------
function getParameterizationConsoleMessage()
  local consoleString = ""
  local nScrollBackLines = table.maxn(parameterizationConsoleMessages)
  for i = 1, nScrollBackLines do
    consoleString = consoleString..parameterizationConsoleMessages[i].."<br>"
  end
  return consoleString
end


