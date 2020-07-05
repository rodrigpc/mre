--[[----------------------------------------------------------------------------

  Application Name:
  TableControl

  Summary:
  Basic implementation of a table control in the User Interface

  Description:
  This sample shows how to use a table control in the UI-Builder. The bindings
  are set in the UIBuilder and are also defined and used from the script. The
  information necessary can be found in the App properties, in the options and
  bindings of the control as well in this script. The fields in the table are
  defined in the options of the control. The table control expects a JSON string
  which must match the defined options. Also it is necessary to set the PreSet
  or PostGet value in the Advanced tab of the controls binding dialog depending
  on direction. In this sample the table is filled with random entries when
  clicking on 'Add Row'. If selecting a row, the index and the string
  representation of that row are printed to the console. Removing a selected row
  is possible with the 'Remove Selected' button.

  How to run:
  This sample can be run on the Emulator or on a device. After starting, the
  the user interface can be seen at the DevicePage in AppStudio or by using
  a web browser.

------------------------------------------------------------------------------]]
--Start of Global Scope---------------------------------------------------------

-- luacheck: globals gAddRow gRemoveRow gPrintSelectedRow gPrintSelectedIndex gBuildJSON

-- Serving the functions and events to use for the control binding
Script.serveEvent('TableControl.OnTableChanged', 'OnTableChanged', 'string')

Script.serveFunction('TableControl.addRow', 'gAddRow')
Script.serveFunction('TableControl.removeRow', 'gRemoveRow')
Script.serveFunction( 'TableControl.printSelectedRow', 'gPrintSelectedRow', 'string' )
Script.serveFunction( 'TableControl.printSelectedIndex', 'gPrintSelectedIndex', 'int' )

-- Variables for selected row and table data
local selectedIndex = 0
local tableControlData = {}

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

local _APPNAME = Engine.getCurrentAppName()

local function main()
  print('App ' .. _APPNAME .. ' started, see Page in DevicePage tab or Browser')
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

-- Adding row with random data and notifying event to update table
function gAddRow()
  local value = math.random(1, 20)
  local nameValue = 'Random Name ' .. tostring(value)
  local stateValue = 'false'
  if value <= 10 then
    stateValue = 'true'
  end
  local idValue = tostring(value)
  local row = {
    idValue = idValue,
    nameValue = nameValue,
    stateValue = stateValue
  }
  table.insert(tableControlData, row)
  Script.notifyEvent('OnTableChanged', gBuildJSON(tableControlData))
end

-- Removing selected row and notifying event to update table
function gRemoveRow()
  if selectedIndex > 0 then
    table.remove(tableControlData, selectedIndex)
    Script.notifyEvent('OnTableChanged', gBuildJSON(tableControlData))
  else
    print 'Invalid selection'
  end
end

-- Printing string representation of selected row
--@gPrintSelectedRow(row:string)
function gPrintSelectedRow(row)
  print('Selected row data: ' .. row)
end

-- Printing index of selected row
--@gPrintSelectedIndex(index:int)
function gPrintSelectedIndex(index)
  selectedIndex = index + 1
  print('Selected row index: ' .. tostring(selectedIndex))
end

-- Building JSON string, parsing the lua table
--@gBuildJSON(data:table)
function gBuildJSON(data)
  local tableData = '['
  local row = {}
  for i, v in ipairs(data) do
    if i >= 2 then
      tableData = tableData .. ','
    end
    row[i] =
      '{"idValue":' ..
      v.idValue ..
        ', "nameValue":"' ..
          v.nameValue .. '", "stateValue" :' .. v.stateValue .. '}'
    tableData = tableData .. row[i]
  end
  local tableString = tableData .. ']'
  return tableString
end

--@getTableData():string
local function getTableData()
  return gBuildJSON(tableControlData)
end
Script.serveFunction('TableControl.getTableData', getTableData)
--End of Function and Event Scope-----------------------------------------------
