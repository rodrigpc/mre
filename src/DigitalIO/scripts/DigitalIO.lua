--[[----------------------------------------------------------------------------

  Application Name:  GettingStarted_DigitalIO

  Description:
  Digital output is toggled depending on digital input state and state changes.

  Script observes digital input #1 ("DI1") for changes. The digital output #1
  ("DO1") is toggled when digital input #2 ("DI2") is set to high. If DI2
  is set to low, the output stays unchanged.
  The FullFeatured Emulator can be used to demonstrate this script. To toggle the input
  states the keyboard shortcuts (Key-1, Key-2) must be used in the emulator tab.

------------------------------------------------------------------------------]]
--Start of Global Scope -------------------------------------------------------

-- Creating ports
-- luacheck: globals gPortDI1 gPortDI2 gPortDO1 gToggleOutput1
gPortDI1 = Connector.DigitalIn.create('DI1')
gPortDI2 = Connector.DigitalIn.create('DI2')
gPortDO1 = Connector.DigitalOut.create('DO1')

-- Registration to changes of Input #1
Connector.DigitalIn.register(gPortDI1, 'OnChange', 'gToggleOutput1')

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope -------------------------------------------

-- Function is called when Input 1 changes
function gToggleOutput1(state)
  -- Toggle output #1 when input #2 is high
  if (Connector.DigitalIn.get(gPortDI2) == true) then
    Connector.DigitalOut.set(gPortDO1, not state)
  end
end

--End of Function and Event Scope -----------------------------------------------
