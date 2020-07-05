--luacheck: ignore gTcpClient gCam gJobs gActualJob gDigOut4 gSysType

--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************

if gSysType ~= 4 then
  -- Configuration of Digital Output
  gDigOut4:setLogic("ACTIVE_HIGH")
  gDigOut4:setPortOutputMode("PUSH_PULL")
  gDigOut4:setActivationMode("TIME_MS")
  gDigOut4:setActivationValue(200)
end

--**************************************************************************
--**********************End Global Scope ***********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

--@createTCPsocket(status:string):
-- Function to send data via TCP Connection
local function sendDataViaTCP(data)
  local success = gTcpClient:transmit(data)
  if success == 0 then
    print("TCP Data Out failed")
  end
end
Script.serveFunction("ColorSorter.sendDataViaTCP", sendDataViaTCP)

-- Function to react on received data via TCP Connection
-- "TRG" -> Trigger new image if camera trigger mode = Ethernet
-- "CHGJOB#" -> Change job to number "#" if "#" 1-5
local function receiveData(data)
  local cmd = string.sub(data, 1, 6)
  if data == "TRG" and gJobs[gActualJob]["tcpIpActive"] and gJobs[gActualJob]["triggerMode"] == 4 then
    gCam:snapshot()
  elseif cmd == "CHGJOB" and gJobs[gActualJob]["tcpIpActive"] then
    local jobNo = string.sub(data, 7, 7)
    if tonumber(jobNo) >= 1 and tonumber(jobNo) <= 5 then
      ColorSorter.setJob(tonumber(jobNo))
      Script.notifyEvent("OnNewJobSelectedViaEthernet", tonumber(jobNo))
    else
      sendDataViaTCP("ERR")
    end
  end
end

--@createTCPsocket(status:bool):
-- Function to create TCP connection if activated
local function createTCPsocket(status)
  if status == true then
    if gTcpClient:isConnected() == true then
      gTcpClient:disconnect()
    end
    gTcpClient:deregister('OnReceive', receiveData)
    gTcpClient:setIPAddress(gJobs[gActualJob]["tcpIpServerAddress"])
    gTcpClient:setPort(gJobs[gActualJob]["tcpIpPort"])
    gTcpClient:setFraming('\02', '\03', '\02', '\03') -- STX/ETX framing for transmit and receive
    gTcpClient:register('OnReceive', receiveData)
    gTcpClient:connect()
  else
    gTcpClient:deregister('OnReceive', receiveData)
    if gTcpClient:isConnected() == true then
      gTcpClient:disconnect()
    end
  end
end
Script.serveFunction("ColorSorter.createTCPsocket", createTCPsocket)

--**************************************************************************
--**********************End Function Scope *********************************
--**************************************************************************