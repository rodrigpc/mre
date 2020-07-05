--[[----------------------------------------------------------------------------

  Application Name: DimensioningFlows                                                                                                                        
                                                                                             
  Description:                                                               
  Dimensioning implemented as DataFlow with served functions from script.
  
  Summary:
  This sample wires a typical dimensioning sample to calculate the size of objects
  moving in front of one scanner. It filters the incoming scans, removes background 
  and creates a PointCloud. Also a trigger is simulated and for every trigger gate 
  the dimension of an object is calculated. The object is viewed with the overlay 
  in the PointCloud view on the webpage.
  
  How to run:
  To view this sample, run it with the emulator and see that Triggers are generated 
  on and off. Open the PointCloud viewer on the webpage and see at every Trigger off 
  a new object with its dimension.
    
------------------------------------------------------------------------------]]

--Start of Global Scope--------------------------------------------------------- 

-- Serve the blocks implemented in lua to the engine
Script.serveFunction("DimensioningFlows.generateTrigger", "generateTrigger", "const object:1:Scan", "bool")
Script.serveFunction("DimensioningFlows.transformToPointCloud", "transformToPointCloud", "const object:1:Scan", "object:1:PointCloud")
Script.serveFunction("DimensioningFlows.printResult", "printResult", "object:1:result")
-- Global blocks status variables for the TriggerGenerator
triggerState = false
currentCycle = 0
onCycles = 100
offCycles = 2
encoderValue = 0

-- Create and initialize the transformer for the transformToPointCloud function
transformer = Scan.Transform.create()
Scan.Transform.setPosition(transformer, 10, -344, -2069)
Scan.Transform.setAlphaBetaGamma(transformer, 1.5708, 0, 1.781)

--End of Global Scope----------------------------------------------------------- 


--Start of Function and Event Scope---------------------------------------------

-- This function generates a trigger on/off depending on the number of incoming scans
-- This simulates a trigger gate
-- Also in simulates the increasing encoder value per case as input for the pointcloud transformation
function generateTrigger(scan)
  currentCycle = currentCycle + 1
  encoderValue = encoderValue + 1
  if (triggerState) then
    if (currentCycle > onCycles) then
      triggerState = false
      currentCycle = 1
      encoderValue = 0
      print("Trigger Off")
    end
  else
    if (currentCycle > offCycles) then
      triggerState = true
      currentCycle = 1
      print("Trigger On")
    end
  end
  return triggerState
end

-- Transform the incoming scans to a PointCloud
-- The XOffset has to be changed for every Scan to have a real 3D PointCloud
-- Cannot be set by FlowEditor currently (engine below would make it)
function transformToPointCloud(scan)
  Scan.Transform.setXOffset(transformer, encoderValue)
  return Scan.Transform.transformToPointCloud(transformer, scan)
end

--prints the result to the console 
function printResult(result)
local length, width, height = PointCloud.Dimensioning.Result.getDimension(result)
    local realvolume = PointCloud.Dimensioning.Result.getRealVolume(result)
    local boxvolume = PointCloud.Dimensioning.Result.getBoxVolume(result)
    local angle = PointCloud.Dimensioning.Result.getAngle(result)
    local resultString = "Object Length = " ..length.. " mm / Width = " ..width.. " mm / Height = " ..height.. " mm / "
                        .. "BoxVolume = " ..boxvolume.. " cm^3 / Angle = " ..string.format("%.2f", math.deg(angle)).. " deg"
    print(resultString)
end

--End of Function and Event Scope------------------------------------------------



