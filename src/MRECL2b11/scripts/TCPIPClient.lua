--Start of Global Scope---------------------------------------------------------

-- Create tcp ip client
-- luacheck: globals gClient
gClient = TCPIPClient.create()
if not gClient then
  print('Could not create TCPIPClient')
end
TCPIPClient.setIPAddress(gClient, '192.168.0.10')
TCPIPClient.setPort(gClient, 10000)
TCPIPClient.setFraming(gClient, '', '', '', '') -- No framing for transmit and receive
TCPIPClient.register(gClient, 'OnReceive', 'gHandleReceive')
TCPIPClient.connect(gClient)
math.randomseed(DateTime.getTimestamp())

for i = 1, 10 do
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000000000000000000000001', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000000000000000000000010', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000000000000000000000100', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000000000000000000001000', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000000000000000000010000', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000000000000000000100000', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000000000000000001000000', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000000000000000010000000', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000000000000000100000000', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000000000000001000000000', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000000000000010000000000', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000000000000100000000000', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000000000001000000000000', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000000000010000000000000', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000000000100000000000000', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000000001000000000000000', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000000010000000000000000', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000000100000000000000000', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000001000000000000000000', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000010000000000000000000', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000100000000000000000000', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000001000000000000000000000', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000010000000000000000000000', 2)))
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000100000000000000000000000', 2)))
--                                         0987654321098765432109876543210987654321
--                                                            2         1         0
  Script.sleep(50)
  TCPIPClient.transmit(gClient, tostring(tonumber('00000000000000000000000000000000', 2)))
  Script.sleep(50)
end

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

-- Function is called when data is received
-- luacheck: globals gHandleReceive

function gHandleReceive(data)
  --if (data ~= '') then
    print(data)
    -- TCPIPClient.transmit(gClient, '10000000')
  --end
end

--End of Function and Event Scope------------------------------------------------

