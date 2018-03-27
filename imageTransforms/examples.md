# Image Transforms

A collection of tasks that wrap ENVI doits for color space tranforms. See below for more details and examples for how to run each task.

These examples assume that you have not placed the tasks in ENVI's custom code folder and are running from IDL with this repository added to IDL's search path. For the proper way to install the tasks, see [https://github.com/envi-idl/TaskAndExtensionInstallGuide](https://github.com/envi-idl/TaskAndExtensionInstallGuide).

For specific details about all task parameters for the tasks listed below, view the associated **.task** file in this folder.

## Processing Requirements

In order to perform a correct, forward color transform on the data (to HLS or HSV spaces), the input raster **must** have data values between 0 and 255. To accomplish this, with IDL you can use of the stretch rasters listed below which also provide links to the documentation. In the examples, the `ENVILinearPercentStretchRaster` is what is used.

- [ENVIEqualizationStretchRaster](http://www.harrisgeospatial.com/docs/enviequalizationstretchraster.html)

- [ENVIGaussianStretchRaster](http://www.harrisgeospatial.com/docs/envigaussianstretchraster.html)

- [ENVILinearPercentStretchRaster](http://www.harrisgeospatial.com/docs/envilinearpercentstretchraster.html)

- [ENVILinearRangeStretchRaster](http://www.harrisgeospatial.com/docs/envilinearrangestretchraster.html)

- [ENVILogStretchRaster](http://www.harrisgeospatial.com/docs/envilogstretchraster.html)

- [ENVIOptimizedLinearStretchRaster](http://www.harrisgeospatial.com/docs/envioptimizedlinearstretchraster.html)

- [ENVIRootStretchRaster](http://www.harrisgeospatial.com/docs/envirootstretchraster.html)


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

; Stretch our data so that we are in 0-255 RGB space
Stretched = ENVILinearPercentStretchRaster(subset)

; Get the  task from the catalog of ENVITasks
Task = ENVITask('XTRGBtoHLSRaster')
Task.INPUT_RASTER = Stretched
Task.OUTPUT_RASTER_URI = e.GetTemporaryFilename()
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

; Stretch our data so that we are in 0-255 RGB space
Stretched = ENVILinearPercentStretchRaster(subset)

; Get the  task from the catalog of ENVITasks
Task = ENVITask('XTRGBtoHSVRaster')
Task.INPUT_RASTER = Stretched
Task.OUTPUT_RASTER_URI = e.GetTemporaryFilename()
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

; Process a spectral subset (three bands)
Subset = ENVISubsetRaster(Raster, BANDS = [0,1,2])

; Stretch our data so that we are in 0-255 RGB space
stretched = ENVILinearPercentStretchRaster(subset)

; Generate an HLS raster
forwardTask = ENVITask('XTRGBtoHLSRaster')
forwardTask.INPUT_RASTER = stretched
forwardTask.Execute

; Convert back to RGB
inverseTask = ENVITask('XTHLStoRGBRaster')
inverseTask.INPUT_RASTER = forwardTask.OUTPUT_RASTER
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
Layer3 = View1.CreateLayer(inverseTask.OUTPUT_RASTER, BANDS = [2,1,0])
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

; Process a spectral subset (three bands)
Subset = ENVISubsetRaster(Raster, BANDS = [0,1,2])

; Stretch our data so that we are in 0-255 RGB space
stretched = ENVILinearPercentStretchRaster(subset)

; Generate an HLS raster
forwardTask = ENVITask('XTRGBtoHSVRaster')
forwardTask.INPUT_RASTER = stretched
forwardTask.Execute

; Convert back to RGB
inverseTask = ENVITask('XTHSVtoRGBRaster')
inverseTask.INPUT_RASTER = forwardTask.OUTPUT_RASTER
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
Layer3 = View1.CreateLayer(inverseTask.OUTPUT_RASTER, BANDS = [2,1,0])
```