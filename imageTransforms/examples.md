# Image Transforms

Here are some example code snippets for how to run these tasks from IDL. This assumes that you have not placed the tasks in ENVI's custom code folder. For the proper way to install the tasks, see [https://github.com/envi-idl/TaskAndExtensionInstallGuide](https://github.com/envi-idl/TaskAndExtensionInstallGuide).


## XTRGBtoHLSRaster

This tasks wraps the ENVI Classic `rgb_trans_doit` and converts an image from red/green/blue (RGB) to hue/lightness/saturation (HLS). The below example creates an HLS raster from RGB.

```idl
; Start the application
e = ENVI()

; Load our extra tasks
xtTasksInit

; Open an input file
File = Filepath('qb_boulder_msi', Subdir=['data'], $
  Root_Dir=e.Root_Dir)
Raster = e.OpenRaster(File)

; Process a spectral subset
Subset = ENVISubsetRaster(Raster, BANDS = [0,1,2])

; Get the  task from the catalog of ENVITasks
Task = ENVITask('XTRGBtoHLSRaster')

; Define inputs
Task.INPUT_RASTER = Subset

; Define outputs
Task.OUTPUT_RASTER_URI = e.GetTemporaryFilename()

; Run the task
Task.Execute

; Get the collection of data objects currently available in the Data Manager
DataColl = e.Data

; Add the output to the Data Manager
DataColl.Add, Task.OUTPUT_RASTER

; Display the result
View1 = e.GetView()
Layer1 = View1.CreateLayer(Subset)
Layer2 = View1.CreateLayer(Task.OUTPUT_RASTER)
```

## XTRGBtoHSVRaster

This tasks wraps the ENVI Classic `rgb_trans_doit` and converts an image from red/green/blue (RGB) to hue/lightness/saturation (HLS). The below example creates an HSV raster from RGB.

```idl
; Start the application
e = ENVI()

; Load our extra tasks
xtTasksInit

; Open an input file
File = Filepath('qb_boulder_msi', Subdir=['data'], $
  Root_Dir=e.Root_Dir)
Raster = e.OpenRaster(File)

; Process a spectral subset
Subset = ENVISubsetRaster(Raster, BANDS = [0,1,2])

; Get the  task from the catalog of ENVITasks
Task = ENVITask('XTRGBtoHSVRaster')

; Define inputs
Task.INPUT_RASTER = Subset

; Define outputs
Task.OUTPUT_RASTER_URI = e.GetTemporaryFilename()

; Run the task
Task.Execute

; Get the collection of data objects currently available in the Data Manager
DataColl = e.Data

; Add the output to the Data Manager
DataColl.Add, Task.OUTPUT_RASTER

; Display the result
View1 = e.GetView()
Layer1 = View1.CreateLayer(Subset)
Layer2 = View1.CreateLayer(Task.OUTPUT_RASTER)
```

## XTHLStoRGBRaster

This tasks wraps the ENVI Classic `rgb_itrans_doit` and converts an image from hue/lightness/saturation (HLS) to red/green/blue (RGB). The below example creates an HLS raster and then performs the inverse transform to RGB.

```idl
; Start the application
e = ENVI()

; Load our extra tasks
xtTasksInit

; Open an input file
File = Filepath('qb_boulder_msi', Subdir=['data'], $
  Root_Dir=e.Root_Dir)
Raster = e.OpenRaster(File)

; Process a spectral subset
Subset = ENVISubsetRaster(Raster, BANDS = [0,1,2])

; Generate an HLS raster
forwardTask = ENVITask('XTRGBtoHLSRaster')
forwardTask.INPUT_RASTER = Subset
forwardTask.Execute

; Convert back to RGB
inverseTask = ENVITask('XTHLStoRGBRaster')
inverseTask.INPUT_RASTER = Task.OUTPUT_RASTER
inverseTask.Execute

; Get the collection of data objects currently available in the Data Manager
DataColl = e.Data

; Add the output to the Data Manager
DataColl.Add, forwardTask.OUTPUT_RASTER
DataColl.Add, inverseTask.OUTPUT_RASTER

; Display the result
View1 = e.GetView()
Layer1 = View1.CreateLayer(Subset)
Layer2 = View1.CreateLayer(forwardTask.OUTPUT_RASTER)
Layer3 = View1.CreateLayer(inverseTask.OUTPUT_RASTER)
```

## XTHSVtoRGBRaster

This tasks wraps the ENVI Classic `rgb_itrans_doit` and converts an image from hue/saturation/value (HSV) to red/green/blue (RGB). The below example creates an HSV raster and then performs the inverse transform to RGB.

```idl
; Start the application
e = ENVI()

; Load our extra tasks
xtTasksInit

; Open an input file
File = Filepath('qb_boulder_msi', Subdir=['data'], $
  Root_Dir=e.Root_Dir)
Raster = e.OpenRaster(File)

; Process a spectral subset
Subset = ENVISubsetRaster(Raster, BANDS = [0,1,2])

; Generate an HLS raster
forwardTask = ENVITask('XTRGBtoHSVRaster')
forwardTask.INPUT_RASTER = Subset
forwardTask.Execute

; Convert back to RGB
inverseTask = ENVITask('XTHSVtoRGBRaster')
inverseTask.INPUT_RASTER = Task.OUTPUT_RASTER
inverseTask.Execute

; Get the collection of data objects currently available in the Data Manager
DataColl = e.Data

; Add the output to the Data Manager
DataColl.Add, forwardTask.OUTPUT_RASTER
DataColl.Add, inverseTask.OUTPUT_RASTER

; Display the result
View1 = e.GetView()
Layer1 = View1.CreateLayer(Subset)
Layer2 = View1.CreateLayer(forwardTask.OUTPUT_RASTER)
Layer3 = View1.CreateLayer(inverseTask.OUTPUT_RASTER)
```