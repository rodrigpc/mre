Script.serveEvent("CalibrationSetup.OnNewMaxNumImages", "OnNewMaxNumImages", "int")
Script.serveEvent("CalibrationSetup.OnNewTimeStep", "OnNewTimeStep", "int")
Script.serveEvent("CalibrationSetup.OnNewIntrinsicCalibrationFilename", "OnNewIntrinsicCalibrationFilename", "string")
Script.serveEvent("CalibrationSetup.OnNewIntrinsicConsoleMessage", "OnNewIntrinsicConsoleMessage", "string")
Script.serveEvent("CalibrationSetup.OnNewTableData", "OnNewTableData", "string")

Script.serveFunction("CalibrationSetup.getIntrinsicConsoleMessage", "getIntrinsicConsoleMessage","","string")
Script.serveFunction("CalibrationSetup.startImageRecording", "startImageRecording")
Script.serveFunction("CalibrationSetup.stopImageRecording", "stopImageRecording")
Script.serveFunction("CalibrationSetup.startCalibration", "startCalibration")
Script.serveFunction("CalibrationSetup.stopCalibration", "stopCalibration")
Script.serveFunction("CalibrationSetup.setCapturedImagesList", "setCapturedImagesList", "string")
Script.serveFunction("CalibrationSetup.setCurrentImageFromTable", "setCurrentImageFromTable", "string")
Script.serveFunction("CalibrationSetup.getCapturedImagesList", "getCapturedImagesList", "", "string")
Script.serveFunction("CalibrationSetup.setSelectedImage", "setSelectedImage")
Script.serveFunction("CalibrationSetup.getSelectedImageStatus", "getSelectedImageStatus", "", "bool")
Script.serveFunction("CalibrationSetup.resetIntrinsic", "resetIntrinsic")
Script.serveFunction("CalibrationSetup.setTableData", "setTableData", "", "string")
Script.serveFunction("CalibrationSetup.selectAllImages", "selectAllImages")
Script.serveFunction("CalibrationSetup.deleteSelectedImagesFromTable", "deleteSelectedImagesFromTable")

-----------------------------------------------------------------------------------------------
-- Start of global scope for the script IntrinsicCalibration.lua
-----------------------------------------------------------------------------------------------
local currentImageIndex = 1
local numImages = 0
local maxNumImages = Parameters.get("MaxNumImages")
local timeStepInMS = Parameters.get("TimeStepInMS")
local recordedImages = {}
local viewImages = {}
local imageList = {}
local selectedImages = {}
local selectedImageStatus = {}
local deleteImageStatus = {}
local timer = nil
local intrinsicFilename = Parameters.get("IntrinsicCameraModelFilename")
local intrinsicConsoleMessages = {}
local maxScrollBackLines = 10
local generalSelection = false
local calibrationStopped = false
local availableImagesIndex = {}
local intCalibrationImageViewer = View.create()
intCalibrationImageViewer:setID("calibrationImageVisualization")

-----------------------------------------------------------------------------------------------
-- Function initIntrinsicCalibration
-- First function prior to intrinsic calibration to be called within main.lua
-----------------------------------------------------------------------------------------------
function initIntrinsicCalibration()
  -- If anything is needed prior to intrinsic calibration, put it here
end

-----------------------------------------------------------------------------------------------
-- Function startImageRecording
-- Creates and start a timer for recording captured camera images with 1000/TimeStepInMS fps
-----------------------------------------------------------------------------------------------
function startImageRecording()
  -- get number max of images to be recorder
  maxNumImages = Parameters.get("MaxNumImages")
  -- get timestep between recorded frames
  timeStepInMS = Parameters.get("TimeStepInMS")
  -- create timer
  timer = Timer.create()
  Timer.register(timer, "OnExpired", "OnExpired")
  Timer.setExpirationTime(timer, timeStepInMS)
  Timer.setPeriodic(timer, true)
  Timer.start(timer)
  -- reset selection status and current image status
  for i = 1,maxNumImages  do
    selectedImages[i] = false
    selectedImageStatus[i] = 0
    deleteImageStatus[i] = false
  end
end

-----------------------------------------------------------------------------------------------
-- Function stopImageRecording
-- Stops timer and sets current image
-----------------------------------------------------------------------------------------------
function stopImageRecording()
  if (timer ~= nil) then
    Timer.stop(timer)
  end
  -- reset selection status and current image status for recorded iamges
  numImages = table.maxn(recordedImages)
  if (numImages > 0) then
    for i = 1,numImages do
      selectedImages[i] = false
      selectedImageStatus[i] = 0
    end
    -- set first image to be current image
    currentImageIndex = 1
    setCurrentImage()
    setTableData()
  end
  Script.notifyEvent("OnImageRecordingStopped")
end

-----------------------------------------------------------------------------------------------
-- Function OnExpired
-- Is called when timer expires and records the current captured image. For visualization the
-- recorded image is resized to 640x480
-----------------------------------------------------------------------------------------------
function OnExpired()
  local nRecordedImages = table.maxn(recordedImages)
  if (nRecordedImages < maxNumImages) then
    nRecordedImages = nRecordedImages+1
    -- recording current image
    recordedImages[nRecordedImages] = currentImage
    -- resizing current image
    viewImages[nRecordedImages] = currentImage
    --Image.resize(currentImage,640,480, "LINEAR")
    imageList[nRecordedImages] = "calibration_image_"..math.floor(nRecordedImages)
    availableImagesIndex[nRecordedImages] = nRecordedImages
    numImages = nRecordedImages
    setIntrinsicConsoleMessage(math.floor(nRecordedImages).. " images recorded")
    local viewImage = viewImages[nRecordedImages]
    -- create a snapshot effect to signal the user that an image has been recorded
    -- by increasing brightness and a sleep call
    local normImage = Image.normalize(viewImage, 0.0, 150.0)
    View.view(intCalibrationImageViewer, Image.addConstant(normImage,100.0))
    setTableData()
    Script.sleep(300)
  else
    -- if recorded images exceeds maxNumImages recording is stopped
    stopImageRecording()
  end
end

-----------------------------------------------------------------------------------------------
-- Function resetIntrinsic
-- Resets the intrinsic calibration. Bound to "Reset" button in the intrinsic calibration page
-----------------------------------------------------------------------------------------------
function resetIntrinsic()
  currentImageIndex = 1
  numImages = 0
  recordedImages = {}
  imageList = {}
  selectedImages = {}
  selectedImageStatus = {}
  deleteImageStatus = {}
  availableImagesIndex = {}
  Parameters.set("ComplexArrayAllTypes","[]") 
  if (timer ~= nil) then
    Timer.stop(timer)
  end
   Script.notifyEvent("OnImageRecordingReset")
   setTableData()
end

-----------------------------------------------------------------------------------------------
-- Function startCalibration
-- Parameterizes and calls the intrinsic calibration procedure implemented in the engine
-----------------------------------------------------------------------------------------------
function startCalibration()
  -- create calibration instance
  calibrationStopped = false
  local calibHandle = Image.Calibration.Camera.create()
  -- specify the calbration target type
  local calibTarget = "CHECKERBOARD"
  local estimationMethod = Parameters.get("ExtrinsicEstimationMethod")
  if estimationMethod == "MATRIX_CODE" then
    calibTarget = "CHECKERBOARD_PLUS_CODE"
  end
  Image.Calibration.Camera.setTargetType(calibHandle, calibTarget)
  -- set checkerboard corner size in mm
  local checkerBoardDimensions = {}
  checkerBoardDimensions[1] = Parameters.get("SquareWidth")
  checkerBoardDimensions[2] = Parameters.get("SquareHeight")
  checkerBoardDimensions[3] = Parameters.get("NumSquaresRow")
  checkerBoardDimensions[4] = Parameters.get("NumSquaresColumn")
  local checkerBoardLengths = {checkerBoardDimensions[1], checkerBoardDimensions[2]}
  local checkerBoardDims = {checkerBoardDimensions[3], checkerBoardDimensions[4]}
  if (checkerBoardDimensions[1] == checkerBoardDimensions[2]) then
    checkerBoardLengths = checkerBoardDimensions[1]
  end
  if (checkerBoardDimensions[3] == checkerBoardDimensions[4]) then
    checkerBoardDims = checkerBoardDimensions[3]
  end
  Image.Calibration.Camera.setCheckerSquareSideLength(calibHandle,
             checkerBoardLengths)
  -- Disable radial distortion coefficients
  Image.Calibration.Camera.setDistortionCoefficientsEnabled(calibHandle, true, true, true, true, true)
  -- Disable skew parameter estimation
  Image.Calibration.Camera.setSkewEnabled(calibHandle, false)
  -- Add selected images to calibration handle
  local nSelectedImages = 0
  for i = 1,numImages do
  if (not calibrationStopped) then
      if (selectedImages[i]) then
        nSelectedImages = nSelectedImages+1
        if estimationMethod == "MATRIX_CODE" then
          local codeReader = Image.CodeReader.create()
          local dmx = Image.CodeReader.DataMatrix.create()
          codeReader:setDecoder("Append", dmx)
          codeReader:setCodeSize2D("VeryBig")
          local codeResult = Image.CodeReader.decode(codeReader, recordedImages[i])
          local codeContent = {}
          local codeRegion = {}
          for j = 1, #codeResult do
            codeContent[j] = Image.CodeReader.Result.getContent(codeResult[j])
            codeRegion[j] = Image.CodeReader.Result.getRegion(codeResult[j])
          end
          if codeContent == nil then
            setIntrinsicConsoleMessage("Error: Matrix codes could not be read")
          else
            setIntrinsicConsoleMessage("Found " .. #codeResult .. " matrix codes in calibration pattern image")
          Image.Calibration.Camera.addImage(calibHandle, recordedImages[i], codeContent, codeRegion)
           end
       else
        Image.Calibration.Camera.addImage(calibHandle, recordedImages[i])
        setIntrinsicConsoleMessage("Processing image " .. i .. " completed")
        end
      end
      end
  end
  -- Perform intrinsic calibration
  local success, cameraModel, calibConfidence, reprojectionError = Image.Calibration.Camera.calculate(calibHandle)
  if not success then
    setIntrinsicConsoleMessage("Error: Intrinsic camera calibration process failed")   
    if (selectedImages < 6) then
      setIntrinsicConsoleMessage("Please select at least 6 images. 11 to 20 images are recommended")   
    end
  else
    setIntrinsicConsoleMessage("Intrinsic camera calibration successful with re-projection error: " .. reprojectionError)
  end
  -- Save intrinsic camera model in the public folder with the given filename
  if (success) then
    intrinsicCameraModel = cameraModel
    intrinsicFilename = Parameters.get("IntrinsicCameraModelFilename")
    Image.Calibration.CameraModel.save(cameraModel, intrinsicFilename)
    setIntrinsicConsoleMessage("Saving intrinsic camera calibration in "..intrinsicFilename)
  end
end

-----------------------------------------------------------------------------------------------
-- Function stopCalibration
-----------------------------------------------------------------------------------------------
function stopCalibration()
  calibrationStopped = true
  -- If anything is needed for stopping intrinsic calibration, put it here
end

-----------------------------------------------------------------------------------------------
-- Function setCurrentImageIndex
-- Sets the currentImageIndex to the argument index
-----------------------------------------------------------------------------------------------
function setCurrentImageIndex(index)
  currentImageIndex = index;
  -- if currentImageIndex is smaller than 1 or bigger than the number of recorded images
  -- currentImageIndex is clipped
  if (currentImageIndex > numImages) then
    currentImageIndex = 1
  elseif (currentImageIndex < 1) then
    currentImageIndex = numImages
  end
end

-----------------------------------------------------------------------------------------------
-- Function setCurrentImage
-- Sets the current image to be shown in the image view
-----------------------------------------------------------------------------------------------
function setCurrentImage()
  View.view(intCalibrationImageViewer, viewImages[currentImageIndex])
end

function setIntrinsicNewImage()
  View.view(intCalibrationImageViewer, currentImage)
end


-----------------------------------------------------------------------------------------------
-- Function getSelectedImageStatus
-- Returns the selection status on the current image
-----------------------------------------------------------------------------------------------
function getSelectedImageStatus()
  return selectedImages[currentImageIndex]
end

-----------------------------------------------------------------------------------------------
-- Function setSelectedImage
-- Inverts the selection status on the current image
-----------------------------------------------------------------------------------------------
function setSelectedImage()
  selectedImages[currentImageIndex] = not selectedImages[currentImageIndex]
end

-----------------------------------------------------------------------------------------------
-- Function getCapturedImagesList
-- Creates the content for the table control within the intrinsic calibration page. The table control
-- shows a list of recorded images, radio buttons indicating which image is currently shown in the
-- image view and checkboxes for de-/selecting images for calibration
-----------------------------------------------------------------------------------------------
function getCapturedImagesList()
  row = {}
  local rowIndex = 0  
  for i = 1,numImages  do
    -- for all recorded images
    -- get the selection status which is a bool
    if recordedImages[i] ~= nil then
      rowIndex = rowIndex+1
      local selectedImageStat = tostring(selectedImages[i])
      -- get the status whether a recorded image is a current image which is a number
      local deleteImageStat = tostring(deleteImageStatus[i])
      local currentImageStatusString = "true"
      -- get image index
      local imageID = imageList[i]
      row[rowIndex] = "{\"deleteStatus\":"..deleteImageStat..",\"name\":\""..imageID.."\", \"selectedStatus\":"..selectedImageStat.."}"
    end
  end
  -- create string for table control
  local tableData = "["
  for i = 1,rowIndex  do
    if (i < rowIndex) then
      tableData = tableData ..row[i]..","
    else
      tableData = tableData ..row[i]
    end
  end
  tableData = tableData .."]"
  --print(tableData)
  return tableData
end


function setTableData()
  local newTableData = getCapturedImagesList()
  Script.notifyEvent("OnNewTableData", newTableData)
  return newTableData
end

-----------------------------------------------------------------------------------------------
-- Function setCapturedImagesList
-- Extracts content from the table control within the intrinsic calibration page. The user interacts
-- with the table control via radio buttons and checkboxes to set the current image or change the
-- selection status of a recorded image. This is encoded in the table control contet. The content
-- is parsed and the flags within the script are set accordingly.
-----------------------------------------------------------------------------------------------
function setCapturedImagesList(tableData)
  local localTableData = tableData
  local previousImageIndex = currentImageIndex
  local currentIndex = 1
  local numAvailableImages = table.maxn(availableImagesIndex)
  for i = 1,numAvailableImages  do
    local sI, startIndex = string.find(localTableData, "deleteStatus",currentIndex)
    currentIndex = startIndex+4
    local selectedStatus = string.sub(localTableData, startIndex+3, startIndex+3)
    if (selectedStatus == "t") then
      deleteImageStatus[availableImagesIndex[i]] = true
    else
      deleteImageStatus[availableImagesIndex[i]] = false
    end
  end
  -- check for all images whether an image has been selected for calibration via checkboxes
  localTableData = tableData
  currentIndex = 1
  for i = 1,numAvailableImages  do
    local sI, startIndex = string.find(localTableData, "selectedStatus",currentIndex)
    currentIndex = startIndex+4
    local selectedStatus = string.sub(localTableData, startIndex+3, startIndex+3)
    if (selectedStatus == "t") then
      selectedImages[availableImagesIndex[i]] = true
    else
      selectedImages[availableImagesIndex[i]] = false
    end
  end
  -- refresh table
  
  setTableData()
   
end

function setCurrentImageFromTable(tableData)
  local localTableData = tableData
  local previousImageIndex = currentImageIndex
  local currentIndex = 1
  -- check for all images whether an image is a current image via radio buttons  
    local sI, startIndex = string.find(localTableData, "calibration_image_",currentIndex)
    local eI, endIndex = string.find(localTableData, ",",sI)
    currentIndex = endIndex
    local imgIndex = tonumber(string.sub(localTableData, startIndex+1,endIndex-2))
    setCurrentImageIndex(imgIndex)
  if (previousImageIndex ~= currentImageIndex) then
    setCurrentImage()
  end
end

function deleteSelectedImagesFromTable()
  local currentImageIndexSet = false
  availableImagesIndex = {}
  for i = 1,numImages  do
    -- for all recorded images
    -- get the selection status which is a bool
    if deleteImageStatus[i] == true then
      recordedImages[i] = nil
      deleteImageStatus[i] = false
    else
      if currentImageIndexSet == false then
        setCurrentImageIndex(i)
        setCurrentImage()      
        currentImageIndexSet = true
      end
      availableImagesIndex[table.maxn(availableImagesIndex)+1] = i
    end
  end
  collectgarbage()
  setTableData()
end

-----------------------------------------------------------------------------------------------
-- Function selectAllImages
-- Selects all recorded images for intrinsic calibration. Bound to the button "Select All Images"
-- within intrinsic calibration page
-----------------------------------------------------------------------------------------------
function selectAllImages()
  -- use global flag generalSelection to remember previous selection status for all images
  for i = 1,numImages  do
    if recordedImages[i] ~= nil then
      selectedImages[i] = not generalSelection
    else
      selectedImages[i] = false
    end
  end
  generalSelection = not generalSelection
  setTableData()
end

-----------------------------------------------------------------------------------------------
-- Function setIntrinsicConsoleMessage
-- Adds the argument message (newest message element) to the intrinsicConsoleMessages for
-- displaying info, status, and error messages relevant to the intrinsic
-- calibration. Not more than maxScrollBackLines messages are stored. Older messages are deleted
-----------------------------------------------------------------------------------------------
function setIntrinsicConsoleMessage(message)
  local nScrollBackLines = table.maxn(intrinsicConsoleMessages)
  if (nScrollBackLines < maxScrollBackLines) then
    nScrollBackLines = nScrollBackLines+1
    intrinsicConsoleMessages[nScrollBackLines] = message
  else
    -- if nScrollBackLines >= maxScrollBackLines, first message in intrinsicConsoleMessages is overwritten
    -- by shifting all array elements and adding the newest message to intrinsicConsoleMessages
    for i = 1, nScrollBackLines-1 do
      intrinsicConsoleMessages[i] = intrinsicConsoleMessages[i+1]
    end
    intrinsicConsoleMessages[nScrollBackLines] = message
  end
  local consoleString = getIntrinsicConsoleMessage()
  Script.notifyEvent("OnNewIntrinsicConsoleMessage", consoleString)
end

-----------------------------------------------------------------------------------------------
-- Function getIntrinsicConsoleMessage
-- Converts intrinsicConsoleMessages to a console string for static text control in the 
-- intrinsic calibration page
-----------------------------------------------------------------------------------------------
function getIntrinsicConsoleMessage()
  local consoleString = ""
  local nScrollBackLines = table.maxn(intrinsicConsoleMessages)
  for i = 1, nScrollBackLines do
    consoleString = consoleString..intrinsicConsoleMessages[i].."<br>"
  end
  return consoleString
end

