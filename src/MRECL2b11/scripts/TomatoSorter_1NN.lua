--[[----------------------------------------------------------------------------

  Application Name: 
  TomatoSorter_1NN
                                                                                             
  Summary: 
  Training a set of Tomato types and classifying a test set.
  
  How to Run:
  Starting this sample is possible either by running the app (F5) or 
  debugging (F7+F10). 
       
  More Information:
  https://www.cs.bgu.ac.il/~karyeh/One%20nearest%20neighbor%20with%20compression.html
  https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm
  
------------------------------------------------------------------------------]]

--Start of Global Scope--------------------------------------------------------- 

--print("AppEngine Version: ".. Engine.getVersion())

local DELAY = 1000 -- ms between visualization steps for demonstration purpose

-- Creating a viewer
local viewer = View.create()

viewer:setID("viewer2D")

-- Setting up graphical overlay attributes
local textDecoration = View.TextDecoration.create()
textDecoration:setSize(35)
textDecoration:setPosition(25,50)

local trainDecoration = View.ShapeDecoration.create()
trainDecoration:setLineColor(0,0,230)  -- Blue

local testDecoration = View.ShapeDecoration.create()
testDecoration:setLineColor(0,230,0)   -- Green

-- Training set
local TomatoTypesTrain = {"Molho",
                    "Vermelho",
                    "Rosado",
                    "Pintado",
                    "Verde"}

-- Test set
local TomatoTypesTest = {"Molho",
                    "Vermelho",
                    "Rosado",
                    "Pintado",
                    "Verde"}

-- Variable to hold histograms
local allTrainHistograms = {}   

--End of Global Scope----------------------------------------------------------- 


--Start of Function and Event Scope---------------------------------------------

function main()
--  criaimagens()
  viewer:clear()
  train()
  classify()
  --print("App finished.")
end

Script.register("Engine.OnStarted", main)

-- Help function to concatenate histograms (as 1D-tables)
function tableConcat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

-- Training each Tomato type by its histogram in HSV color space
function train()
  for i = 1, #TomatoTypesTrain do    
    local img = Image.load("resources/Train/"..tostring(i)..".png")
    viewer:clear()
    local imageID = viewer:addImage(img)
    viewer:addText("Learning: "..tostring(TomatoTypesTrain[i]), textDecoration, nil, imageID)
    viewer:present()
    Script.sleep(DELAY)

    local H,S,V = img:toHSV()
    local histogramH, centersH = H:getHistogram()
    local histogramS, centersS = S:getHistogram()
    local histogramV, centersV = V:getHistogram()
    local HS = tableConcat(histogramH, histogramS)
    local HSV = tableConcat(HS, histogramV)  -- Concatenate H, S and V channels after one another
    allTrainHistograms[i] = HSV
  end
end


-- Classifying test set
function classify()
  local classification = {} -- Array to store classification results
  local hora = DateTime.getTimestamp()
  local maximo = 0
  local diferenca = 0
  local quantidade = 100
  for j = 1, quantidade do
    -- local img = Image.load("resources/Test/"..tostring(j)..".png")
    local hora2 = DateTime.getTimestamp()
    math.randomseed(DateTime.getTimestamp())
    -- loading addiotnal images
    local img01 = Image.load("resources/Fonte/"..tostring(math.random(6))..".png")
    local img02 = Image.load("resources/Fonte/"..tostring(math.random(6))..".png")
    local img03 = Image.load("resources/Fonte/"..tostring(math.random(6))..".png")
    local img04 = Image.load("resources/Fonte/"..tostring(math.random(6))..".png")
    
    -- merging images
    local imgS01 = Image.concatenate(img01, img02, "RIGHT")
    local imgS02 = Image.concatenate(img03, img04, "RIGHT")
    local img = Image.concatenate(imgS01, imgS02, "RIGHT")

    viewer:clear()
    local imageID = viewer:addImage(img)
    
    local H,S,V = img:toHSV()
    local histogramH, centersH = H:getHistogram() 
    local histogramS, centersS = S:getHistogram() 
    local histogramV, centersV = V:getHistogram() 
    local HS = tableConcat(histogramH, histogramS)
    local HSV = tableConcat(HS, histogramV)
   
    -- Comparing histogram of test image j with all training images    
    local allHistogramDiffs = {} -- Array to store histogram comparisons
    for k = 1, #TomatoTypesTrain do
      allHistogramDiffs[k] = Statistics.compareHistograms(HSV,allTrainHistograms[k])
      -- print(math.floor(allHistogramDiffs[k]))
    end
   
    -- Find the key of the smallest value from the histogram comparison array   
    local key, min = 1, allHistogramDiffs[1]
    for k, v in ipairs(allHistogramDiffs) do
      if allHistogramDiffs[k] < min then
        key, min = k, v
      end
    end
        
    -- The key of the min comparison value equals the key of the Tomato type in the training set
    classification[j] = TomatoTypesTrain[key]
    --print(classification[j])
    diferenca = DateTime.getTimestamp()-hora2
    viewer:addText("Classifying: "..tostring(classification[j]).. " em "..tostring(diferenca).." milisegundos", textDecoration, nil, imageID)
    viewer:present()
    if diferenca > maximo then
      maximo = diferenca
    end
    -- Script.sleep(DELAY/10)
  end
  viewer:addText("Tempo médio: "..tostring((DateTime.getTimestamp()-hora)/quantidade).. " milisegundos, máximo de "..tostring(maximo), textDecoration, nil, imageID)
  viewer:present()
end

--End of Function and Event Scope-------------------------------------------------- 
