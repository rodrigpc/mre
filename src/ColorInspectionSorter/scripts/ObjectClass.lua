--luacheck: ignore gJobs gSelectRegionColor

--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************

function gSelectRegionColor(colorValue)
  if colorValue >= 166 or colorValue <= 5 then
    return 1
  elseif colorValue >= 6 and colorValue <= 20 then
    return 2
  elseif colorValue >= 21 and colorValue <= 39 then
    return 3
  elseif colorValue >= 40 and colorValue <= 95 then
    return 4
  elseif colorValue >= 96 and colorValue <= 105 then
    return 5
  elseif colorValue >= 106 and colorValue <= 119 then
    return 6
  elseif colorValue >= 120 and colorValue <= 165 then
    return 7
  end
end

local item = {}
function item:new(jobNo, colorNo)
  local obj = {}
  setmetatable(obj, self)
  self.__index = self
  obj.colorActive = Parameters.get("Job[" .. tostring(jobNo-1) .. "]/Object[" .. tostring(colorNo-1) .. "]/ColorActive")
  obj.colorMode = Parameters.get("Job[" .. tostring(jobNo-1) .. "]/Object[" .. tostring(colorNo-1) .. "]/ColorMode")
  obj.value = Parameters.get("Job[" .. tostring(jobNo-1) .. "]/Object[" .. tostring(colorNo-1) .. "]/ColorValue")
  obj.regionColor = Parameters.get("Job[" .. tostring(jobNo-1) .. "]/Object[" .. tostring(colorNo-1) .. "]/RegionColorValue")
  obj.tolerance = Parameters.get("Job[" .. tostring(jobNo-1) .. "]/Object[" .. tostring(colorNo-1) .. "]/ColorTolerance")
  obj.minBlobSize = Parameters.get("Job[" .. tostring(jobNo-1) .. "]/Object[" .. tostring(colorNo-1) .. "]/MinBlobSize")
  obj.maxBlobSize = Parameters.get("Job[" .. tostring(jobNo-1) .. "]/Object[" .. tostring(colorNo-1) .. "]/MaxBlobSize")
  obj.minGood = Parameters.get("Job[" .. tostring(jobNo-1) .. "]/Object[" .. tostring(colorNo-1) .. "]/MinGood")
  obj.maxGood = Parameters.get("Job[" .. tostring(jobNo-1) .. "]/Object[" .. tostring(colorNo-1) .. "]/MaxGood")
  obj.centerX_ROI = Parameters.get("Job[" .. tostring(jobNo-1) .. "]/Object[" .. tostring(colorNo-1) .. "]/ROI_CenterX")
  obj.centerY_ROI = Parameters.get("Job[" .. tostring(jobNo-1) .. "]/Object[" .. tostring(colorNo-1) .. "]/ROI_CenterY")
  obj.width_ROI = Parameters.get("Job[" .. tostring(jobNo-1) .. "]/Object[" .. tostring(colorNo-1) .. "]/ROI_Width")
  obj.height_ROI = Parameters.get("Job[" .. tostring(jobNo-1) .. "]/Object[" .. tostring(colorNo-1) .. "]/ROI_Height")
  obj.center_ROI = Point.create(obj.centerX_ROI, obj.centerY_ROI)
  obj.ROI = Shape.createRectangle(obj.center_ROI, obj.width_ROI, obj.height_ROI)
  obj.roiActive = Parameters.get("Job[" .. tostring(jobNo-1) .. "]/Object[" .. tostring(colorNo-1) .. "]/ROI_Active")
  return obj
end

local job = {}
function job:new(number)
  local obj = {}
  setmetatable(obj, self)
  self.__index = self
  obj.jobName = Parameters.get("Job[" .. tostring(number-1) .. "]/JobName")

  -- Cam parameters
  obj.camIP = Parameters.get("Job[" .. tostring(number-1) .. "]/CameraIP")
  obj.camSubnet = Parameters.get("Job[" .. tostring(number-1) .. "]/CameraSubnet")
  obj.triggerMode = Parameters.get("Job[" .. tostring(number-1) .. "]/TriggerMode")
  obj.shutterTime = Parameters.get("Job[" .. tostring(number-1) .. "]/ShutterTime")
  obj.framerate = Parameters.get("Job[" .. tostring(number-1) .. "]/Framerate")
  obj.gain = Parameters.get("Job[" .. tostring(number-1) .. "]/Gain")/10
  obj.scaleFactor = Parameters.get("Job[" .. tostring(number-1) .. "]/Scalefactor")/10

  obj.foregroundImage = Parameters.get("Job[" .. tostring(number-1) .. "]/ForegroundImage")
  obj.backgroundImage = Parameters.get("Job[" .. tostring(number-1) .. "]/BackgroundImage")
  obj.minForeground = Parameters.get("Job[" .. tostring(number-1) .. "]/ForegroundMin")
  obj.maxForeground = Parameters.get("Job[" .. tostring(number-1) .. "]/ForegroundMax")
  obj.minBackground = Parameters.get("Job[" .. tostring(number-1) .. "]/BackgroundMin")
  obj.maxBackground = Parameters.get("Job[" .. tostring(number-1) .. "]/BackgroundMax")

  obj.tcpIpActive = Parameters.get("Job[" .. tostring(number-1) .. "]/TcpIpSetActive")
  obj.tcpIpPort = Parameters.get("Job[" .. tostring(number-1) .. "]/TcpIpPort")
  obj.tcpIpServerAddress = Parameters.get("Job[" .. tostring(number-1) .. "]/TcpIpServerIpAddress")
  
  obj.tcpIpOutMode = Parameters.get("Job[" .. tostring(number-1) .. "]/TcpIpOutputMode")
  
  obj.digOutActive = Parameters.get("Job[" .. tostring(number-1) .. "]/DigitalOutputActive")

  table.insert(obj, 1, item:new(number, 1))
  table.insert(obj, 2, item:new(number, 2))
  table.insert(obj, 3, item:new(number, 3))
  table.insert(obj, 4, item:new(number, 4))
  table.insert(obj, 5, item:new(number, 5))
  table.insert(obj, 6, item:new(number, 6))
  table.insert(obj, 7, item:new(number, 7))
  table.insert(obj, 8, item:new(number, 8))
  table.insert(obj, 9, item:new(number, 9))
  table.insert(obj, 10, item:new(number, 10))
  table.insert(obj, 11, item:new(number, 11))
  table.insert(obj, 12, item:new(number, 12))
  return obj
end

table.insert(gJobs, 1, job:new(1))
table.insert(gJobs, 2, job:new(2))
table.insert(gJobs, 3, job:new(3))
table.insert(gJobs, 4, job:new(4))
table.insert(gJobs, 5, job:new(5))
table.insert(gJobs, 6, job:new(6))
table.insert(gJobs, 7, job:new(7))
table.insert(gJobs, 8, job:new(8))
table.insert(gJobs, 9, job:new(9))
table.insert(gJobs, 10, job:new(10))

--**************************************************************************
--**********************End Global Scope ***********************************
--**************************************************************************
