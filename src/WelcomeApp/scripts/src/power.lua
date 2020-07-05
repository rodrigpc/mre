require("include/power_h")

local JSON = require("src/util/json")

local FILE = "/private/power.json"

local powerConnectors = Engine.getEnumValues("PowerConnectors")
local used_connectors = {}
local connectionsAreApplied = false

table.sort(powerConnectors)

for i = #powerConnectors, 1, -1 do
    local name = powerConnectors[i]
    if (name:match("^INMAIN$") or name:match("^VIN%d$")) then
        table.remove(powerConnectors, i)
    else
        used_connectors[name] = {}
        used_connectors[name].power = false
        used_connectors[name].handle = Connector.Power.create(name)
    end
end

local selected = ""

buildJSONForTable = function()
    local j = {}
    for k, v in pairs(powerConnectors) do
        j[k] = {connector = v, state = used_connectors[v].power}
    end
    return JSON.stringify(j)
end

applyConnections = function()
    for _, cont in pairs(used_connectors) do
        cont.handle:enable(cont.power)
    end
    connectionsAreApplied = true
    Script.notifyEvent("onConnectionsAreApplied", connectionsAreApplied)
end

storeConnections = function()
    applyConnections()
    local j = {}
    for k, v in pairs(powerConnectors) do
        j[v] = used_connectors[v].power
    end
    local f = File.open(FILE, "w")
    f:write(JSON.stringify(j))
    f:close()
end

readConnections = function()
    if File.exists(FILE) then
        local f = File.open(FILE, "r")
        local j = f:read()
        f:close()
        
        collectgarbage()
        
        for k, v in pairs(JSON.parse(j)) do
            used_connectors[k].power = v
        end
        
        selected = ""
        Script.notifyEvent("onConnectorTable", buildJSONForTable())
        connectionsAreApplied = false
        Script.notifyEvent("onConnectionsAreApplied", connectionsAreApplied)
    end
end

eraseConnections = function()
    File.del(FILE)
    
    for k, _ in pairs(used_connectors) do
        used_connectors[k].power = false
        used_connectors[k].handle:enable(false)
    end
    
    collectgarbage()
    
    selected = ""
    Script.notifyEvent("onConnectorTable", buildJSONForTable())
    Script.notifyEvent("Power_onSelected", selected)
    connectionsAreApplied = true
    Script.notifyEvent("onConnectionsAreApplied", connectionsAreApplied)
end

getConnectionsAreApplied = function()
    return connectionsAreApplied
end

getConnectorTable = function()
    return buildJSONForTable()
end

tableSelectionChanged = function(rowData)
    local j = JSON.parse(rowData)
    if used_connectors[j[1].connector] then
        used_connectors[j[1].connector].power = not used_connectors[j[1].connector].power
        Script.notifyEvent("onConnectorTable", buildJSONForTable())
    end
    connectionsAreApplied = false
    Script.notifyEvent("onConnectionsAreApplied", connectionsAreApplied)
end

readConnections()
applyConnections()
