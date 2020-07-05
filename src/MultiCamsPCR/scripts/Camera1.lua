------------------------------------------------------------------------------------------------------------------------
-- Setup camera 1
------------------------------------------------------------------------------------------------------------------------
function setupCamera1()
  -- Create a Remote camera config
  config1 = Image.Provider.RemoteCamera.I2DConfig.create()
  config1:setShutterTime(shTim)
  config1:setAcquisitionMode("FIXED_FREQUENCY")
  config1:setFrameRate(frRate)
  config1:setGainFactor(gainFact)
  --config1:setColorMode(clrMode)

  -- Create a remote camera
  camera1 = Image.Provider.RemoteCamera.create()
  camera1:setType("I2DCAM")
  camera1:setIPAddress("192.168.1.100")
  camera1:setConfig(config1)
  camera1:register("OnNewImage", "OnNewImage1")
  
  -- Connect the camera
  local success = camera1:connect()
  if success then
    print "Successfully connected to camera 1."
  else
    print "Camera not found."
  end
end

------------------------------------------------------------------------------------------------------------------------
-- Start acquisition from camera 1
------------------------------------------------------------------------------------------------------------------------
function startCamera1()
  local success = camera1:start()
  if success then
    print("Image acquisition from camera 1 started.")
  else
    print("Could not start image acquisition from camera 1.")
  end
end

------------------------------------------------------------------------------------------------------------------------
-- Callback for camera 1
------------------------------------------------------------------------------------------------------------------------
function OnNewImage1(img)
  print("New image from cam 1 received.")
  view1:view(img)
end
