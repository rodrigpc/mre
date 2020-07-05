--------------------------------------------------------------------------------
-- FUNCTIONS
-------------

local buildJSONForTable
local applyConnections
local storeConnections
local readConnections
local eraseConnections
local getConnectorTable
local tableSelectionChanged
local getConnectionsAreApplied

--------------------------------------------------------------------------------
-- SERVES
----------

Script.serveFunction(_APPNAME .. ".Power.getConnectorTable", "getConnectorTable")
Script.serveFunction(_APPNAME .. ".Power.tableSelectionChanged", "tableSelectionChanged")
Script.serveFunction(_APPNAME .. ".Power.storeConnectionsClicked", "storeConnections")
Script.serveFunction(_APPNAME .. ".Power.readConnectionsClicked", "readConnections")
Script.serveFunction(_APPNAME .. ".Power.eraseConnectionsClicked", "eraseConnections")
Script.serveFunction(_APPNAME .. ".Power.getConnectionsAreApplied", "getConnectionsAreApplied")

Script.serveEvent(_APPNAME .. ".Power.onConnectorTable", "onConnectorTable")
Script.serveEvent(_APPNAME .. ".Power.onConnectionsAreApplied", "onConnectionsAreApplied")
