--Start of Global Scope---------------------------------------------------------

-- luacheck: globals gPowerSer1 gComSer1

-- Enable power on Serial port 1, must be adapted if another port is used

gPowerSer1 = Connector.Power.create('SER1')
Connector.Power.enable(gPowerSer1, true)

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

-- Wait for boot up of conencted device after power is enabled
-- Script.sleep(3000)

-- Creating serial port for serial port 1, must be adapted if another port is used
-- Serial interface settings are configured corresponding to connected device
gComSer1 = SerialCom.create('SER1')
SerialCom.setType(gComSer1, 'RS232')
SerialCom.setTermination(gComSer1, true)
SerialCom.setDataBits(gComSer1, 8)
SerialCom.setStopBits(gComSer1, 1)
SerialCom.setParity(gComSer1, 'N')
SerialCom.setBaudRate(gComSer1, 38400)
SerialCom.setHandshake(gComSer1, false)
SerialCom.setFramingBufferSize(gComSer1, 21000, 21000)


--SerialCom.setFraming(gComSer1, '\02', '\03', '\02', '\03') -- STX/ETX framing for transmit and receive
 SerialCom.setFraming(gComSer1, '', '', '', '')



local function handleTransmitSer1(data)
  -- Received data is processed to extract the relevant information, this needs to be
  -- adapted to the connected device.
  if SerialCom.transmit(gComSer1, data) == 0 then
    print('Failed!')
  end
  print(data)
  
 -- SerialCom.setTermination(gComSer1, true)
 Connector.Power.enable(gPowerSer1, false)
end



local function handleReceiveSer1(data)
  -- Received data is processed to extract the relevant information
  local receivedData = tostring(SerialCom.receive(gComSer1, data))
  local systemStatus = string.sub(receivedData, 1, 2)
  print('Dados recebidos: ' .. receivedData)
  print('System status: ' ..  systemStatus)
  return systemStatus
end



-- Establish/acivate the serial interface
local isOpen = SerialCom.open(gComSer1)
if (not isOpen) then
  print('could not open serial port.')
end
local deNovo = true
while deNovo do
  local retorno = handleReceiveSer1(100)
  if retorno == "11" then
    
    handleTransmitSer1('12121100000000000000')
   
  elseif retorno == "0" then
    deNovo = false
    print("Sistema parado")
  else
   print("Não recebido em 100 ms")
  end
end


