--[[----------------------------------------------------------------------------

  Application Name:
  HTTPClientSample

  Summary:
  This sample shows the usage of HTTPClient to request resources via HTTP and
  HTTPS protocols.

  Description:
  The sample provides a performHttpGetRequest() method which will be invoked with
  two sample URLs. The content available at these URLs will then be fetched. If
  an URL starts with https:// a secure connection will automatically be
  established and the peer side's certificate will be validated against a list
  of known, trusted authorities by default. The validation can be disabled but
  this makes the connection a lot less secure.

  How to run:
  Deploy the app to any device capable of HTTP(S) (use app assurance to validate)
  and run it. Depending on your network configuration it might be necessary to
  provide HTTP proxy settings (see source code). This app also runs on the
  FullFeatured emulator.

  Implementation:
  There are some commented out sections giving hints to additional configuration
  options.

------------------------------------------------------------------------------]]
-- Configuration for connection to the server

local httpServer = 'http://192.168.0.10/change.htm'
local httpsServer = 'https://www.sick.com/de/de'
local client

local function performHttpGetRequest(url)
  -- Create HTTPClient handle
  client = HTTPClient.create()
  if not client then
    print('Error creating handle')
    return
  end

  -- Configure proxy (if needed)
  
  client:setProxy("http://192.168.0.10", 80)
  client:setProxyAuth("sm1012", "sm1012")
  
  
  -- Setup certificate authority bundle. You can download this bundle from the
  -- curl website https://curl.haxx.se/docs/caextract.html
  client:setCABundle('resources/cacert.pem')
  client:setPeerVerification(true)
  client:setHostnameVerification(false)

  -- Create request
  local request = HTTPClient.Request.create()
  request:setURL(url)
  -- The port is selected automatically based on the protocol (http/https) but
  -- can be set manually if needed by uncommenting this line:
  -- request:setPort(port)
  request:setContentType("application/x-www-form-urlencoded")
  
  request:setContentBuffer("/change.htm?file=7&element=19&value=9999")
  request:addHeader("file" , 7)
  request:addHeader("element" , 19)
  request:addHeader("value" , 9999)
  request:setMethod('GET')
  -- Execute request
  local response = client:execute(request)

  -- Check success
  local success = response:getSuccess()
  if not success then
    local error = response:getError()
    local errorDetails = response:getErrorDetail()
    print('Error: ' .. error)
    print('Detail: ' .. errorDetails)
  end

  if success then
    -- Print HTTP Status code
    print('Status code: ' .. response:getStatusCode())

    -- Output HTTP response headers
    for _, v in ipairs(response:getHeaderKeys()) do
      local _, values = response:getHeaderValues(v)
      print(string.format('  > %s: %s', v, table.concat(values, ', ')))
    end

    -- Output content summary
    print(
      string.format('\nReceived %d bytes\n', string.len(response:getContent()))
    )
  -- .. or content itself by uncommenting this line:
  -- print(response:getContent())
  end
end

performHttpGetRequest(httpServer)
--performHttpGetRequest(httpsServer)
