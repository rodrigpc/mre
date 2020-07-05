------------------------------------ START OF INITIALIZATION PART ------------------------------------------------------
-- Global variables
PowerMode = 1  -- 1=PIO, 2=POE
shTim = 50000 -- Shutter Time in miliseconds
gainFact = 100.0 -- Gain Factor
frRate = 1.00 -- Frame Rate
clrMode = "COLOR8" -- Color Mode

-- Include lua files
require("Camera1")
require("Camera2")

-- Setup hardware

powerS1 = Connector.Power.create("S1")      -- PIO on camera 1
powerS1:enable(true)
powerS2 = Connector.Power.create("S2")      -- PIO on camera 2
powerS2:enable(true)




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