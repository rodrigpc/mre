------------------------------------------------------------------------------------------------------------------------
-- Setup camera 2
------------------------------------------------------------------------------------------------------------------------
function setupCamera2()
  -- Create a Remote camera config
  config2 = Image.Provider.RemoteCamera.I2DConfig.create()
  config2:setShutterTime(shTim)
  config2:setAcquisitionMode("FIXED_FREQUENCY")
  config2:setFrameRate(frRate)
  config2:setGainFactor(gainFact)
  --config2:setColorMode(clrMode)

  -- Create a remote camera
  camera2 = Image.Provider.RemoteCamera.create()
  camera2:setType("I2DCAM")
  camera2:setIPAddress("192.168.1.101")
  camera2:setConfig(config2)
  camera2:register("OnNewImage", "OnNewImage2")
  
  -- Connect the camera
  local success = camera2:connect()
  if success then
    print "Successfully connected to camera 2."
  else
    print "Camera not found."
  end
end

------------------------------------------------------------------------------------------------------------------------
-- Start acquisition from camera 2
------------------------------------------------------------------------------------------------------------------------
function startCamera2()
  local success = camera2:start()
  if success then
    print("Image acquisition from camera 2 started.")
  else
    print("Could not start image acquisition from camera 2.")
  end
end

------------------------------------------------------------------------------------------------------------------------
-- Callback for camera 2
------------------------------------------------------------------------------------------------------------------------
function OnNewImage2(img)
  print("New image from cam 2 received.")
  view2:view(img)
end
