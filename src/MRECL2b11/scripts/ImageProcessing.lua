--luacheck: ignore gJobs gActualJob gDigOut4 gSelectRegionColor gCamSetupViewerActive gProcessResults gResultViewerActive gColorSelecterActive
--luacheck: ignore gHandleOnNewImageProcessing gTempImage gActualColor gRoiEditorActive gViewerImageID
--luacheck: ignore gInstalledEditorIconic gOrgViewer gResViewer gConfigViewer gCamSetupViewer gCheckIfOfflineMode gSysType

--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************

-- Decorations for visualization
local shapeDeco = {}

local decorationOK = View.ShapeDecoration.create()
decorationOK:setFillColor(0, 127, 195, 50)
decorationOK:setLineWidth(3)

local decoPixelRegionGood = View.PixelRegionDecoration.create()
decoPixelRegionGood:setColor(0, 255, 0, 100)

local decoPixelRegionBad = View.PixelRegionDecoration.create()
decoPixelRegionBad:setColor(255, 0, 0, 100)

local decoPixelRegionGreen = View.PixelRegionDecoration.create()
decoPixelRegionGreen:setColor(0, 255, 0, 255)

-- Hue value 166-180 & 1-15
local shapeDecoRed = View.ShapeDecoration.create()
shapeDecoRed:setLineColor(255, 0, 0)
shapeDecoRed:setLineWidth(8)
-- Hue value 15-25
local shapeDecoOrange = View.ShapeDecoration.create()
shapeDecoOrange:setLineColor(255, 165, 0)
shapeDecoOrange:setLineWidth(8)
-- Hue value 26-39
local shapeDecoYellow = View.ShapeDecoration.create()
shapeDecoYellow:setLineColor(255, 255, 0)
shapeDecoYellow:setLineWidth(8)
-- Hue value 40-69
local shapeDecoGreen = View.ShapeDecoration.create()
shapeDecoGreen:setLineColor(0, 255, 0)
shapeDecoGreen:setLineWidth(8)
-- Hue value 70-99
local shapeDecoCyan = View.ShapeDecoration.create()
shapeDecoCyan:setLineColor(0, 255, 255)
shapeDecoCyan:setLineWidth(8)
-- Hue value 100-135
local shapeDecoBlue = View.ShapeDecoration.create()
shapeDecoBlue:setLineColor(0, 0, 255)
shapeDecoBlue:setLineWidth(8)
-- Hue value 136-165
local shapeDecoPurple = View.ShapeDecoration.create()
shapeDecoPurple:setLineColor(255, 0, 255)
shapeDecoPurple:setLineWidth(8)

table.insert(shapeDeco, 1, shapeDecoRed)
table.insert(shapeDeco, 2, shapeDecoOrange)
table.insert(shapeDeco, 3, shapeDecoYellow)
table.insert(shapeDeco, 4, shapeDecoGreen)
table.insert(shapeDeco, 5, shapeDecoCyan)
table.insert(shapeDeco, 6, shapeDecoBlue)
table.insert(shapeDeco, 7, shapeDecoPurple)

--local results = {}
local endResult

local gotImageSize = false
local imageSizeX, imageSizeY
local imageID = 'Image'
local roiID = 'ROI'
local pipetteID = 'Pipette'

local centerPoint = Point.create(100, 100)
local pipetteROI  = Shape.createRectangle(centerPoint, 200, 200)
local tempPipetteROI  = Shape.createRectangle(centerPoint, 200, 200)

local pipetteMode = false
local checkColorOfROI = false

--**************************************************************************
--**********************End Global Scope ***********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

--@handleOnNewImage(image:Image,sensorData:SensorData)
-- Function for image processing
function gHandleOnNewImageProcessing(image)
  -- Show image in Camera Setup Viewer
  if gCamSetupViewerActive == true then
    local smallImage = Image.resizeScale(image, gJobs[gActualJob]["scaleFactor"], gJobs[gActualJob]["scaleFactor"], "LINEAR")
    gCamSetupViewer:clear()
    gCamSetupViewer:addImage(smallImage)
    gCamSetupViewer:present("LIVE")
    gTempImage = image
  end

  local tic = DateTime.getTimestamp()
  -- Only process if Color Setup or Result processing
  if gColorSelecterActive == true or gProcessResults == true then
    if gColorSelecterActive == true or ColorSorter.getOfflineDemoMode() == true then
      gTempImage = image
    end
    
    if gJobs[gActualJob]["scaleFactor"] ~= 1 then
      image = image:resizeScale(gJobs[gActualJob]["scaleFactor"], gJobs[gActualJob]["scaleFactor"])
    end
    -- If pipette is activated in UI
    if pipetteMode == true then
      if gInstalledEditorIconic == nil then
        gConfigViewer:clear()
        gConfigViewer:addImage(image, nil, imageID)
        gConfigViewer:addShape(pipetteROI, decorationOK, pipetteID, imageID)
        gConfigViewer:installEditor(pipetteID)
        gInstalledEditorIconic = pipetteID
        gConfigViewer:present()
      end
      return
    end
    
    -- Separate image in Hue, Saturation, Value images
    local images = {}
    local imageH, imageS, imageV = image:toHSV()

    table.insert(images, 1, imageH)
    table.insert(images, 2, imageS)
    table.insert(images, 3, imageV)

    -- Get and set value of color pipette for actual color if just configured
    if checkColorOfROI == true then
      local meanHueValue
      if gJobs[gActualJob][gActualColor]["colorMode"] == 1 then
        if gSysType ~= 4 then
          meanHueValue = Image.getMean(imageH, Shape.toPixelRegion(tempPipetteROI, imageH))
        else
          _, __, meanHueValue = Image.PixelRegion.getStatistics(Shape.toPixelRegion(tempPipetteROI, imageH), imageH)
        end
      else
        if gSysType ~= 4 then
          meanHueValue = Image.getMean(imageV, Shape.toPixelRegion(tempPipetteROI, imageV))
        else
          _, __, meanHueValue = Image.PixelRegion.getStatistics(Shape.toPixelRegion(tempPipetteROI, imageV), imageV)
        end
      end
      local mean = math.floor(meanHueValue)
      gJobs[gActualJob][gActualColor]["value"] = mean
      gJobs[gActualJob][gActualColor]["regionColor"] = gSelectRegionColor(gJobs[gActualJob][gActualColor]["value"])
      checkColorOfROI = false
      Script.notifyEvent("OnNewPipetteValue", mean)
    end

    -- Set ROI for actual color if just configured
    if gRoiEditorActive == true and gColorSelecterActive == true then
      if gInstalledEditorIconic == nil then
        gConfigViewer:clear()
        gConfigViewer:addImage(image, nil, imageID)
        gConfigViewer:addShape(gJobs[gActualJob][gActualColor]["ROI"], decorationOK, roiID, imageID)
        gConfigViewer:installEditor(roiID)
        gInstalledEditorIconic = roiID
        gConfigViewer:present()
      end
      --Get Size of Image if not already got
      if gotImageSize == false then
        imageSizeX = Image.getWidth(image)/gJobs[gActualJob]["scaleFactor"]
        imageSizeY = Image.getHeight(image)/gJobs[gActualJob]["scaleFactor"]
        gotImageSize = true
      end
      return
    end

    gConfigViewer:clear()

    -- Threshold on selected image to find foreground (all objects)
    local foreground
    local foregroundImage

    foreground = images[gJobs[gActualJob]["foregroundImage"]]:threshold(gJobs[gActualJob]["minForeground"], gJobs[gActualJob]["maxForeground"])
    foregroundImage = images[gJobs[gActualJob]["foregroundImage"] ]

    if gViewerImageID == 1 and gColorSelecterActive == true then
      local parentID = gConfigViewer:addImage(foregroundImage, nil, imageID)
      gConfigViewer:addPixelRegion(foreground, decoPixelRegionGood, nil, parentID)
      gConfigViewer:present()
      return
    end

    -- Threshold on selected image to differentiate between foreground and background
    local nonColoredForeground
    local backgroundImage

    nonColoredForeground = images[gJobs[gActualJob]["backgroundImage"]]:threshold(gJobs[gActualJob]["minBackground"], gJobs[gActualJob]["maxBackground"])
    backgroundImage = images[gJobs[gActualJob]["backgroundImage"]]

    if gViewerImageID == 2 and gColorSelecterActive == true then
      local parentID = gConfigViewer:addImage(backgroundImage, nil, imageID)
      gConfigViewer:addPixelRegion(nonColoredForeground, decoPixelRegionBad, nil, parentID)
      gConfigViewer:present()
      return
    end

    -- Reduce Image just to colored Items
    local coloredForegroundBase = Image.PixelRegion.getDifference(foreground, nonColoredForeground)
    --local grayForegroundBase = Image.PixelRegion.getDifference(foreground, nonColoredForeground)
    
    if gViewerImageID == 3 and gColorSelecterActive == true then
      local parentID = gConfigViewer:addImage(images[ColorSorter.getImageToShow()], nil, imageID)
      if ColorSorter.getShowAOI() == true then
        gConfigViewer:addPixelRegion(coloredForegroundBase, decoPixelRegionGreen, nil, parentID)
      end
      gConfigViewer:present()
      return
    end
    
    endResult = true
    local parentID

    if gResultViewerActive == true then
      gOrgViewer:clear()
      gOrgViewer:addImage(images[ColorSorter.getImageToShow()])
      gResViewer:clear()
      parentID = gResViewer:addImage(image)
    end

    -- Check if in Color Setup Mode (only 1 color to check) or Run Mode (check all active colors)
    local start = 1
    local k = 12
    if gColorSelecterActive == true then
      start = gActualColor
      k = gActualColor
    end

    local objCounter = {}
    local results = {}
    
    -- Check colors
    for i = start, k do
      local blobsCnt = 0
      local blobMax = 0
      local blobMin = 0

      local coloredForeground

      if gJobs[gActualJob][i]["colorActive"] == true then
        if gJobs[gActualJob][i]["roiActive"] == true then
          coloredForeground = Image.PixelRegion.getIntersection(coloredForegroundBase, Shape.toPixelRegion(gJobs[gActualJob][i]["ROI"], imageV))
        else
          coloredForeground = coloredForegroundBase
        end
        
        -- Find pixels with specified color value
        local colorRegion
        local colorRegionAdditional

        if gJobs[gActualJob][i]["colorMode"] == 1 then
          if gJobs[gActualJob][i]["value"]-gJobs[gActualJob][i]["tolerance"] < 0 then
            colorRegion = imageH:threshold(1, gJobs[gActualJob][i]["value"]+gJobs[gActualJob][i]["tolerance"], coloredForeground)
            colorRegionAdditional = imageH:threshold(180+(gJobs[gActualJob][i]["value"]-gJobs[gActualJob][i]["tolerance"]), 180, coloredForeground)
            colorRegion = Image.PixelRegion.getUnion(colorRegion, colorRegionAdditional)
          elseif gJobs[gActualJob][i]["value"]-gJobs[gActualJob][i]["tolerance"] == 0 then
            colorRegion = imageH:threshold(1, gJobs[gActualJob][i]["value"]+gJobs[gActualJob][i]["tolerance"], coloredForeground)
          elseif gJobs[gActualJob][i]["value"]+gJobs[gActualJob][i]["tolerance"] > 180 then
            colorRegion = imageH:threshold(gJobs[gActualJob][i]["value"]-gJobs[gActualJob][i]["tolerance"], 180, coloredForeground)
            colorRegionAdditional = imageH:threshold(1, (gJobs[gActualJob][i]["value"]+gJobs[gActualJob][i]["tolerance"])-180, coloredForeground)
            colorRegion = Image.PixelRegion.getUnion(colorRegion, colorRegionAdditional)
          else
            colorRegion = imageH:threshold(gJobs[gActualJob][i]["value"]-gJobs[gActualJob][i]["tolerance"], gJobs[gActualJob][i]["value"]+gJobs[gActualJob][i]["tolerance"], coloredForeground)
          end
        else
          colorRegion = imageV:threshold(gJobs[gActualJob][i]["value"]-gJobs[gActualJob][i]["tolerance"], gJobs[gActualJob][i]["value"]+gJobs[gActualJob][i]["tolerance"], coloredForeground)
        end

        -- Only select areas with connected color-pixels
        local blobs = colorRegion:findConnected(gJobs[gActualJob][i]["minBlobSize"], gJobs[gActualJob][i]["maxBlobSize"])

        if #blobs ~= 0 then
          blobMax = blobs[1]:countPixels()
          blobMin = blobs[#blobs]:countPixels()
          blobsCnt = #blobs
        end

        if blobsCnt >= gJobs[gActualJob][i]["minGood"] and blobsCnt <= gJobs[gActualJob][i]["maxGood"] then
          --results[i] = true
          table.insert(results, true)
        else
          --results[i] = false
          table.insert(results, false)
        end

        table.insert(objCounter, blobsCnt)

        -- If Color Setup Viewer is active, show image and found objects
        if gViewerImageID == 4 and gColorSelecterActive == true then
          if gJobs[gActualJob][gActualColor]["colorMode"] == 1 then
            parentID = gConfigViewer:addImage(image, nil, imageID)
          else
            parentID = gConfigViewer:addImage(imageV, nil, imageID)
          end
          gConfigViewer:addPixelRegion(colorRegion, decoPixelRegionGreen, nil, parentID)

          for j = 1, #blobs do
            local boundingBox = blobs[j]:getBoundingBox(image)
            gConfigViewer:addShape(boundingBox, shapeDecoGreen, nil, parentID)
          end

          gConfigViewer:present()

          Script.notifyEvent("OnNewBlobsActualColor", tostring(#blobs))
          Script.notifyEvent("OnNewBlobsActualColorMinBlob", tostring(blobMin))
          Script.notifyEvent("OnNewBlobsActualColorMaxBlob", tostring(blobMax))
          return

        -- If Result Viewer is active, show image and found objects
        elseif gResultViewerActive == true then
          for j = 1, #blobs do
            local boundingBox = blobs[j]:getBoundingBox(image)
            gResViewer:addShape(boundingBox, shapeDeco[gJobs[gActualJob][i]["regionColor"]], "blob"..tostring(i)..tostring(j), parentID)
          end
        end
        --endResult = results[i] and endResult
        endResult = results[#results] and endResult

      else
        --results[i] = true
      end
      ColorSorter.checkToNotifyResult(i, blobsCnt, blobMin, blobMax, tostring(results[#results]))
    end

    -- Send results via Digital IO if activated
    if gJobs[gActualJob]["digOutActive"] == true and gProcessResults == true then
      Connector.DigitalOut.set(gDigOut4, endResult)
      Connector.DigitalOut.set(gDigOut4, false)
    end

    -- Send results via Ethernet if activated
    if gJobs[gActualJob]["tcpIpOutMode"] == 2 and gJobs[gActualJob]["tcpIpActive"] and gProcessResults == true then
      
      -- Only End Result
      ColorSorter.sendDataViaTCP(tostring(endResult))

    elseif gJobs[gActualJob]["tcpIpOutMode"] == 3 and gJobs[gActualJob]["tcpIpActive"] and gProcessResults == true then
    
      -- Single Results + End Result
      local resultString = ""
      print("Results = " .. tostring(#results))
      if #results >= 1 then
        resultString = tostring(results[1])
        for i=2, #results do
          resultString = resultString .. "," .. tostring(results[i])
        end
      end
      --ColorSorter.sendDataViaTCP(tostring(endResult) .. "," .. tostring(results[1]) .. "," .. tostring(results[2]) .. "," .. tostring(results[3]) .. "," .. tostring(results[4]))
      ColorSorter.sendDataViaTCP(resultString .. "," .. tostring(endResult))

    elseif gJobs[gActualJob]["tcpIpOutMode"] == 4 and gJobs[gActualJob]["tcpIpActive"] and gProcessResults == true then
    
    -- Single Values + End Result
      local resultString = ""
      if #objCounter >= 1 then
        resultString = tostring(objCounter[1])
        for i=2, #objCounter do
          resultString = resultString .. "," .. tostring(objCounter[i])
        end
      end
      ColorSorter.sendDataViaTCP(resultString .. "," .. tostring(endResult))
    end

    Script.notifyEvent("OnNewResult", endResult)
    Script.notifyEvent("OnNewResultGood", true)
    Script.notifyEvent("OnNewResultBad", false)

     if gResultViewerActive == true then
       gOrgViewer:present()
       gResViewer:present()
     end
  end
  local toc = DateTime.getTimestamp()
  Script.notifyEvent("OnNewProcessingTime", tostring(toc-tic) .. "ms.")
  print(tostring(toc-tic) .. "ms")
end

--**********************************
-- Region of Interest Functions
--**********************************
--@handleOnPointerEditor(iconicId:undefined,pointerActionType:undefined,pointerType:undefined)
-- Function to react on selected ROI
local function handleOnPointerEditor(iconicId, pointerActionType, pointerType)
  if pointerType == 'PRIMARY' and pointerActionType == 'CLICKED' then
    if gInstalledEditorIconic == iconicId then
      -- Nothing to do, editor is already installed on selected ID
      return
    end
    -- Deinstalling editor if it is installed on another iconic than the currently selected
    if gInstalledEditorIconic and gInstalledEditorIconic ~= iconicId then
      gConfigViewer:uninstallEditor(gInstalledEditorIconic)
      if gInstalledEditorIconic == pipetteID then
        pipetteMode = false
        checkColorOfROI = true
        gCheckIfOfflineMode()
      end
      gInstalledEditorIconic = nil
    end
    -- Installing editor on the rectangle if selected in the viewer
    if iconicId == roiID then
      gConfigViewer:installEditor(iconicId)
      gInstalledEditorIconic = iconicId
    elseif iconicId == pipetteID then
      gConfigViewer:installEditor(iconicId)
      gInstalledEditorIconic = iconicId
      Script.notifyEvent("OnPipetteActive", true)
    end
    gConfigViewer:present()
  end
end
View.register(gConfigViewer, "OnPointer", handleOnPointerEditor)

--@handleOnChangeEditor(iconicid:string,iconic:object)
-- Is called when the installed editor detects changes of the iconic in the viewer
local function handleOnChangeEditor(iconicId, iconic)
  -- Checking if selected iconic is the added rectangle
  if iconicId == roiID and 'RECTANGLE' == iconic:getType() then
    -- Updating rectangle in script with the one defined in the viewer
    gJobs[gActualJob][gActualColor]["ROI"] = iconic
    --local center, width, height, rotation = gJobs[gActualJob][gActualColor]["ROI"]:getRectangleParameters()
  elseif iconicId == pipetteID then
    tempPipetteROI = iconic
  end
end
View.register(gConfigViewer, 'OnChange', handleOnChangeEditor)

--@setFullRegion():
-- Function to make ROI as big as image size
local function setFullRegion()
  if gInstalledEditorIconic ~= nil then
    gConfigViewer:uninstallEditor(gInstalledEditorIconic)
    gInstalledEditorIconic = nil
  end
  local cP = Point.create(imageSizeX/2, imageSizeY/2)
  local roi  = Shape.createRectangle(cP, imageSizeX, imageSizeY)
  gJobs[gActualJob][gActualColor]["ROI"] = roi
  gConfigViewer:addShape(gJobs[gActualJob][gActualColor]["ROI"], decorationOK, roiID, imageID)
  gConfigViewer:present()
end
Script.serveFunction("ColorSorter.setFullRegion", setFullRegion)

--@selectColorViaPipette():
-- Function to activate color pipette
local function selectColorViaPipette()
  Script.notifyEvent("OnPipetteActive", false)
  pipetteMode = true
  gRoiEditorActive = false
  gInstalledEditorIconic = nil
  gCheckIfOfflineMode()
end
Script.serveFunction("ColorSorter.selectColorViaPipette", selectColorViaPipette)

--@getPipetteMode():bool
local function getPipetteMode()
  return true
end
Script.serveFunction("ColorSorter.getPipetteMode", getPipetteMode)


--Select Viewer to show images depending on actual Side

--@handleOnConnect()
local function handleOnConnectCamSetupViewer()
  gCamSetupViewerActive = true
  Script.notifyEvent("OnCameraSetupViewerActive", true)
  gColorSelecterActive = false
  gResultViewerActive = false
  gCamSetupViewer:clear()
  gCamSetupViewer:present()
end
View.register(gCamSetupViewer, "OnConnect", handleOnConnectCamSetupViewer)

local function handleOnConnectConfigViewer()
  gCamSetupViewerActive = false
  gColorSelecterActive = true
  Script.notifyEvent("OnConfigViewerActive", true)
  gResultViewerActive = false
  gConfigViewer:clear()
  gConfigViewer:present()
end
View.register(gConfigViewer, "OnConnect", handleOnConnectConfigViewer)

local function handleOnConnectResultViewer()
  gCamSetupViewerActive = false
  gColorSelecterActive = false
  if gProcessResults == true then
    gResultViewerActive = true
    Script.notifyEvent("OnResultViewerActive", true)
  else
    gResultViewerActive = false
    Script.notifyEvent("OnResultViewerActive", false)
  end
  gResViewer:clear()
  gOrgViewer:clear()
  gResViewer:present()
  gOrgViewer:present()
end
View.register(gResViewer, "OnConnect", handleOnConnectResultViewer)

--**************************************************************************
--**********************End Function Scope *********************************
--**************************************************************************