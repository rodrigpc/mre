--luacheck: ignore

--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************
-- System Type --> 1=SIM1004, 2=SIM1012, 3=SIM4000, 4=Emulator
gSysType = 4

-- If using the Color Setup
gColorSelecterActive = false
-- If processing (RUN mode)
gProcessResults = true
-- If viewing process results in UI
gResultViewerActive = false
-- If using Camera Setup
gCamSetupViewerActive = false
-- If using local Images in Offline-Mode
gOfflineDemoModeActive = false

-- Actual  job
gActualJob = Parameters.get("ActualJob")
gJobs = {}

gCamTriggerFlow = Flow.create()
gCam1 = Image.Provider.RemoteCamera.create()
gConfig1 = Image.Provider.RemoteCamera.I2DConfig.create()
gDirectoryProvider = Image.Provider.Directory.create()
gIsConnected1 = false

-- Saved image, to see effects of parameters without continous new images
gTempImage = nil

gActualColor = 1
gViewerImageID = 1
gRoiEditorActive = false
gInstalledEditorIconic = nil

gTcpClient = TCPIPClient.create()

gOrgViewer = View.create("orgViewer")
gResViewer = View.create("resViewer")
gConfigViewer = View.create("configViewer")
gCamSetupViewer = View.create("viewer")

--**************************************************************************
--**********************End Global Scope ***********************************
--**************************************************************************
