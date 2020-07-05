------------------------------------ START OF INITIALIZATION PART ------------------------------------------------------
-- Global variables
PowerMode = 1  -- 1=PIO, 2=POE

-- Include lua files
require("Camera1")
require("Camera2")

-- Setup hardware
powerS5 = Connector.Power.create("S5")        -- illumination 1
powerS5:enable(true)
if (PowerMode == 1) then
  powerS6 = Connector.Power.create("S6")      -- PIO on camera 1
  powerS6:enable(true)
  powerPOE2 = Connector.Power.create("POE2")  -- POE on camera 1
  powerPOE2:enable(false)
  powerS7 = Connector.Power.create("S7")      -- PIO on camera 2
  powerS7:enable(true)
  powerPOE3 = Connector.Power.create("POE3")  -- POE on camera 2
  powerPOE3:enable(false)
elseif (PowerMode == 2) then
  powerS6 = Connector.Power.create("S6")      -- PIO on camera 1
  powerS6:enable(false)
  powerPOE2 = Connector.Power.create("POE2")  -- POE on camera 1
  powerPOE2:enable(true)
  powerS7 = Connector.Power.create("S7")      -- PIO on camera 2
  powerS7:enable(false)
  powerPOE3 = Connector.Power.create("POE3")  -- POE on camera 2
  powerPOE3:enable(true)
else
  print("Invalid power mode")
end

-- Wait for remote devices boot up
Script.sleep(5000)

-- Setup viewer
view1 = View.create()
view1:setID("Viewer1")
view2 = View.create()
view2:setID("Viewer2")

-- Setup and connect to cameras
setupCamera1()
setupCamera2()

-- Get image from remote cameras
startCamera1()
startCamera2()
------------------------------------ END OF INITIALIZATION PART --------------------------------------------------------



------------------------------------ START OF EVENT SCOPE --------------------------------------------------------------

------------------------------------END OF EVENT SCOPE -----------------------------------------------------------------