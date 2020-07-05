Script.serveEvent("CalibrationSetup.OnNewExtrinsicCalibrationFilename", "OnNewExtrinsicCalibrationFilename", "string")
Script.serveEvent("CalibrationSetup.OnNewExtrinsicConsoleMessage", "OnNewExtrinsicConsoleMessage", "string")

Script.serveFunction("CalibrationSetup.setExtrinsicCalibrationImage", "setExtrinsicCalibrationImage")
Script.serveFunction("CalibrationSetup.getExtrinsicConsoleMessage", "getExtrinsicConsoleMessage","","string")
Script.serveFunction("CalibrationSetup.startExtrinsicCalibration", "startExtrinsicCalibration")
Script.serveFunction("CalibrationSetup.loadIntrinsicCameraModel", "loadIntrinsicCameraModel")
Script.serveFunction("CalibrationSetup.resetExtrinsic", "resetExtrinsic")

-----------------------------------------------------------------------------------------------
-- Start of global scope for the script ExtrinsicCalibration.lua
-----------------------------------------------------------------------------------------------

local extrinsicFilename = Parameters.get("ExtrinsicCameraModelFilename")
local estimationMethod = Parameters.get("ExtrinsicEstimationMethod")
local cameraType
local extrinsicCalibrationImage
local extrinsicCalibrationImageMatrixCode = Image.load("resources/SampleImages/Extrinsic/matrix_code_img.png") 
local extrinsicCalibrationImageThreeDot = Image.load("resources/SampleImages/Extrinsic/three_dot_img.png") 
local extrinsicCalibrationImageCoordinateCode = Image.load("resources/SampleImages/Extrinsic/coordinate_code_img.png") 
local extrinsicConsoleMessages = {}
local maxScrollBackLines = 10
local extCalibrationImageViewer = View.create()
extCalibrationImageViewer:setID("extrinsicCalibrationImageVisualization")
function initExtrinsicCalibration()
  -- If anything is needed prior extrinsic calibration, put it here
end

-----------------------------------------------------------------------------------------------
-- Function setExtrinsicCalibrationImage
-- Set currently captured image as extrinsic calibration image
-----------------------------------------------------------------------------------------------
function setExtrinsicCalibrationImage()
  if (cameraType == "Directory") then
    estimationMethod = Parameters.get("ExtrinsicEstimationMethod")
    if (estimationMethod ==  "MATRIX_CODE") then
      extrinsicCalibrationImage = Image.clone(extrinsicCalibrationImageMatrixCode)
    elseif (estimationMethod ==  "THREE_DOT") then
      extrinsicCalibrationImage = Image.clone(extrinsicCalibrationImageThreeDot)
    elseif (estimationMethod ==  "COORDINATE_CODE") then
      extrinsicCalibrationImage = Image.clone(extrinsicCalibrationImageCoordinateCode)
    else
      extrinsicCalibrationImage = Image.clone(currentImage)
    end
  else
    extrinsicCalibrationImage = Image.clone(currentImage)
  end
  setExtrinsicConsoleMessage("Setting pose estimation image")
  Script.notifyEvent("OnImageRecordingStopped")
end

function setExtrinsicNewImage(camType)
  cameraType = camType
  if (cameraType == "Directory") then
    estimationMethod = Parameters.get("ExtrinsicEstimationMethod")
    if (estimationMethod ==  "MATRIX_CODE") then
      View.view(extCalibrationImageViewer, extrinsicCalibrationImageMatrixCode)
    elseif (estimationMethod ==  "THREE_DOT") then
      View.view(extCalibrationImageViewer, extrinsicCalibrationImageThreeDot)
    elseif (estimationMethod ==  "COORDINATE_CODE") then
      View.view(extCalibrationImageViewer, extrinsicCalibrationImageCoordinateCode)
    else
      View.view(extCalibrationImageViewer, currentImage)
    end
  else
    View.view(extCalibrationImageViewer, currentImage)
  end
end

-----------------------------------------------------------------------------------------------
-- Function resetExtrinsic
-- Resets the extrinsic calibration. Bound to "Reset" button in the extrinsic calibration page
-----------------------------------------------------------------------------------------------
function resetExtrinsic()
   Script.notifyEvent("OnImageRecordingReset")
end

-----------------------------------------------------------------------------------------------
-- Function startExtrinsicCalibration
-- Parameterizes and calls the extrinsic calibration procedure implemented in the engine.
-- NOTE: Intrinsic camera model must be available prior extrinsic calibration either via
-- calibration the cameras intrinsically first or loading a model from resources or public folder
-----------------------------------------------------------------------------------------------
function startExtrinsicCalibration()
  local camModelOut = nil
  if intrinsicCameraModel ~= nil then    
    if extrinsicCalibrationImage ~= nil then
      local checkerBoardDimensions = {}
      checkerBoardDimensions[1] = Parameters.get("SquareWidth")
      checkerBoardDimensions[2] = Parameters.get("SquareHeight")
      checkerBoardDimensions[3] = Parameters.get("NumSquaresRow")
      checkerBoardDimensions[4] = Parameters.get("NumSquaresColumn")
      local checkerBoardLengths = {checkerBoardDimensions[1], checkerBoardDimensions[2]}
      local checkerBoardDims = {checkerBoardDimensions[3], checkerBoardDimensions[4]}
      
       -- calibrate extrinsically with the given checkerboard parameters, the intrinsic camera model
       -- and the calibration image
       setExtrinsicConsoleMessage("Starting extrinsic calibration with " .. estimationMethod .. " calibration pattern ("
                                 .. checkerBoardDims[1] .. "x" .. checkerBoardDims[2] .. "," .. checkerBoardLengths[1] .. "x" .. checkerBoardLengths[2] ..")")
       if estimationMethod == "MATRIX_CODE" then
         local codeReader = Image.CodeReader.create()
         local dmx = Image.CodeReader.DataMatrix.create()
         codeReader:setDecoder("Append", dmx)
         codeReader:setCodeSize2D("VeryBig")
         local codeResult = Image.CodeReader.decode(codeReader, extrinsicCalibrationImage)
        
         local codeContent = {}
         local codeRegion = {}
         for i = 1, #codeResult do
           codeContent[i] = Image.CodeReader.Result.getContent(codeResult[i])
           codeRegion[i] = Image.CodeReader.Result.getRegion(codeResult[i])
         end
         if codeContent == nil then
           setExtrinsicConsoleMessage("Error: Matrix codes could not be read")
         else
           setExtrinsicConsoleMessage("Found " .. #codeResult .. " matrix codes in calibration pattern")
           if (checkerBoardLengths[1] == checkerBoardLengths[2]) then
             checkerBoardLengths = checkerBoardLengths[1]
           end
           camModelOut, reprojectionError = Image.Calibration.Pose.estimateMatrixCode(extrinsicCalibrationImage,
                                                                 intrinsicCameraModel, codeContent, codeRegion, checkerBoardLengths)
         end
       elseif estimationMethod == "THREE_DOT" then                                                               
         camModelOut, reprojectionError = Image.Calibration.Pose.estimateThreeDot(intrinsicCameraModel,
                                                               extrinsicCalibrationImage, checkerBoardLengths)
      elseif estimationMethod == "COORDINATE_CODE" then                                                               
         camModelOut, reprojectionError = Image.Calibration.Pose.estimateCoordinateCode(intrinsicCameraModel,
                                                               extrinsicCalibrationImage, checkerBoardLengths)
      else
         if checkerBoardLengths[1] == checkerBoardLengths[2] then
            checkerBoardLengths = checkerBoardLengths[1]
         end    
         camModelOut, reprojectionError = Image.Calibration.Pose.estimate(extrinsicCalibrationImage,
                                                                intrinsicCameraModel, checkerBoardLengths)
      end                                                                                                                
    else
      setExtrinsicConsoleMessage("Error: Cannot load pose estimation image")  
    end
  else
    setExtrinsicConsoleMessage("Error: Intrinsic camera model not available")  
  end
  
  -- calibration succeded, store extrinsic camera model in the public folder with the given filename
  if camModelOut ~= nil then
    setExtrinsicConsoleMessage("Extrinsic camera calibration successful with re-projection error: " .. reprojectionError)
    extrinsicFilename = Parameters.get("ExtrinsicCameraModelFilename")
    Image.Calibration.CameraModel.save(camModelOut, extrinsicFilename)    
    setExtrinsicConsoleMessage("Saving extrinsic camera calibration in "..extrinsicFilename)
  else
    setExtrinsicConsoleMessage("Error: Extrinsic camera calibration failed")
  end
end
-----------------------------------------------------------------------------------------------
-- Function loadIntrinsicCameraModel
-- Loads an intrinsic camera model from resources or public folder. Takes the model name from the
-- text input control "Intrinsic camera model filename" and is bound to button "Load Intrinsic Camera Model"
-- witihn extrinsic calibration page
-----------------------------------------------------------------------------------------------
function loadIntrinsicCameraModel()
  local intrinsicCameraModelPath = Parameters.get("IntrinsicCameraModelFilename")
  if (File.exists(intrinsicCameraModelPath)) then
    intrinsicCameraModel = Image.Calibration.CameraModel.load(intrinsicCameraModelPath)
    setExtrinsicConsoleMessage("Intrinsic camera model has been loaded")
  else
    setExtrinsicConsoleMessage("Error: Intrinsic camera model file does not exist")    
  end
end

-----------------------------------------------------------------------------------------------
-- Function setExtrinsicConsoleMessage
-- Adds the argument message (newest message element) to the extrinsicConsoleMessages for
-- displaying info, status, and error messages relevant to the extrinsic
-- calibration. Not more than maxScrollBackLines messages are stored. Older messages are deleted
-----------------------------------------------------------------------------------------------
function setExtrinsicConsoleMessage(message)
  local nScrollBackLines = table.maxn(extrinsicConsoleMessages)
  if (nScrollBackLines < maxScrollBackLines) then
    nScrollBackLines = nScrollBackLines+1
    extrinsicConsoleMessages[nScrollBackLines] = message
  else
    for i = 1, nScrollBackLines-1 do
      extrinsicConsoleMessages[i] = extrinsicConsoleMessages[i+1]
    end
    extrinsicConsoleMessages[nScrollBackLines] = message
  end
    local consoleString = getExtrinsicConsoleMessage()
  Script.notifyEvent("OnNewExtrinsicConsoleMessage",consoleString)
end

-----------------------------------------------------------------------------------------------
-- Function getExtrinsicConsoleMessage
-- Converts extrinsicConsoleMessages to a console string for static text control in the 
-- extrinsic calibration page
-----------------------------------------------------------------------------------------------
function getExtrinsicConsoleMessage()
  local consoleString = ""
  local nScrollBackLines = table.maxn(extrinsicConsoleMessages)
  for i = 1, nScrollBackLines do
    consoleString =   consoleString..extrinsicConsoleMessages[i].."<br>"
  end
  return consoleString
end
