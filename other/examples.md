# Other Tasks

A collection of other, miscellaneous tasks for ENVI.

These examples assume that you have not placed the tasks in ENVI's custom code folder and are running from IDL with this repository added to IDL's search path. For the proper way to install the tasks, see [https://github.com/envi-idl/TaskAndExtensionInstallGuide](https://github.com/envi-idl/TaskAndExtensionInstallGuide).

For specific details about all task parameters for the tasks listed below, view the associated **.task** file in this folder.

## XTCreateRasterPyramid

This will create a Pyramid file for a raster.

```idl
; Start the application
e = ENVI()

; Load our extra tasks
xtTasksInit

; Open an input file
File = Filepath('qb_boulder_msi', Subdir=['data'], $
  Root_Dir=e.Root_Dir)
Raster = e.OpenRaster(File)

; Get the  task from the catalog of ENVITasks
Task = ENVITask('XTCreateRasterPyramid')
Task.INPUT_RASTER = Raster
Task.Execute
```

## XTExtractNameFromRaster

As the task name implies, this tasks extracts the name property from a raster and removes all special characters (those not allowed in filepaths). Here is a short example:

```idl
; Start the application
e = ENVI()

; Load our extra tasks
xtTasksInit

; Open an input file
File = Filepath('qb_boulder_msi', Subdir=['data'], $
  Root_Dir=e.Root_Dir)
Raster = e.OpenRaster(File)

; Get the  task from the catalog of ENVITasks
Task = ENVITask('XTExtractNameFromRaster')
Task.INPUT_RASTER = Raster
Task.Execute

; Print our name to the IDL console
print, task.OUTPUT_STRING
```


## XTSaveROITrainingStatistics

This task saves statistics that were extracted from a raster over regions of interest so that the information persists between ENVI+IDL sessions.

```idl
; Start the application
e = ENVI()

; Load our extra tasks
xtTasksInit

; Open an input file
File = Filepath('qb_boulder_msi', Subdir=['data'], $
  Root_Dir=e.Root_Dir)
Raster = e.OpenRaster(File)

; Open a multi-part ROI
ROIFile = filepath('qb_boulder_roi.xml', $
  ROOT_DIR = e.ROOT_DIR, SUBDIRECTORY = ['data'])
rois = e.OpenROI(ROIFile)

; Get training statistics
StatTask = ENVITask('ROIStatistics')
StatTask.INPUT_RASTER = Raster
StatTask.INPUT_ROI = rois
StatTask.Execute

; Specify the output filename
outFile = e.getTemporaryFilename('json')

; Save our ROI statistics
Task = ENVITask('XTSaveROITrainingStatistics')
Task.MIN = StatTask.MIN
Task.MAX = StatTask.MAX
Task.MEAN = StatTask.MEAN
Task.STDDEV = StatTask.STDDEV
Task.COVARIANCE = StatTask.COVARIANCE
Task.ROI_PIXEL_COUNT = StatTask.ROI_PIXEL_COUNT
Task.ROI_COLORS = StatTask.ROI_COLORS
Task.ROI_NAMES = StatTask.ROI_NAMES
Task.OUTPUT_URI = outFile
Task.Execute

; Print our name to the IDL console
print, outFile
```

## XTFileSearch

This task searches a folder for files for easy processing in ENVI for the ENVI Modeler. It will throw an error if no files are found.

```idl
; Start the application
e = ENVI()

; Load our extra tasks
xtTasksInit

; Search for files while excluding specific file extensions
Task = ENVITask('XTSaveROITrainingStatistics')
Task.DIRECTORY = 'C:\some\folder'
Task.SEARCH_PATTERN = '*.dat'
Task.EXCLUDE_EXTENSIONS = '.dat.enp'
Task.execute

; Get the files
print, Task.OUTPUT_FILES

; Get the number of files
print, Task.COUNT

```

## XTQUACWithBadBandsList

This task lets you process a file with QUAC (atmospheric correction) that first subsets the data with information on bad bands. For the examples below, you must have the same number of bad band elements as there are bands in the raster that will be processed.

This first example uses an IDL array to specify which bands to process (1) and which bands to ignore (0).

```idl
;start ENVI
e = envi(/HEADLESS)

; Open an input file
File = Filepath('qb_boulder_msi', Subdir=['data'], $
  Root_Dir=e.Root_Dir)
Raster = e.OpenRaster(File)

;specify the bad bands array
bad_bands = [1,1,0,1]

; Process with QUAC
quacTask = ENVITask('ROIStatistics')
quacTask.INPUT_BAD_BANDS_ARRAY = bad_bands
quacTask.INPUT_RASTER = Raster
quacTask.SENSOR = 'QuickBird'
quacTask.Execute
```

This second example uses a text file on disk to specify which bands to process (1) and which bands to ignore (0). The text file contains one number per line and empty lines are ignored.

```idl
;start ENVI
e = envi(/HEADLESS)

; Open an input file
File = Filepath('qb_boulder_msi', Subdir=['data'], $
  Root_Dir=e.Root_Dir)
Raster = e.OpenRaster(File)

;specify the bad bands array
bad_bands = [1,1,0,1]

; create a file for the bad bands list
bad_bands_uri = e.getTemporaryFilename('.txt')
openw, lun, bad_bands_uri, /GET_LUN
printf, lun, strtrim(bad_bands,2), /IMPLIED_PRINT
free_lun, lun

; Process with QUAC
quacTask = ENVITask('ROIStatistics')
quacTask.INPUT_BAD_BANDS_URI = bad_bands_uri
quacTask.INPUT_RASTER = Raster
quacTask.SENSOR = 'QuickBird'
quacTask.Execute
```

## XTRestoreROITrainingStatistics

This task saves statistics that were extracted from a raster over regions of interest so that the information persists between ENVI+IDL sessions.

The example below does two things:

1. Saves the information about ROI statistics

2. Restores ste statistics and runs a Spectral Angle Mapper classification


```idl
; Start the application
e = ENVI()

; Load our extra tasks
xtTasksInit

; Open an input file
File = Filepath('qb_boulder_msi', Subdir=['data'], $
  Root_Dir=e.Root_Dir)
Raster = e.OpenRaster(File)

; Open a multi-part ROI
ROIFile = filepath('qb_boulder_roi.xml', $
  ROOT_DIR = e.ROOT_DIR, SUBDIRECTORY = ['data'])
rois = e.OpenROI(ROIFile)

; Get training statistics
StatTask = ENVITask('ROIStatistics')
StatTask.INPUT_RASTER = Raster
StatTask.INPUT_ROI = rois
StatTask.Execute

; Specify the output filename
outFile = e.getTemporaryFilename('json')

; Save our ROI statistics
saveTask = ENVITask('XTSaveROITrainingStatistics')
saveTask.MIN = StatTask.MIN
saveTask.MAX = StatTask.MAX
saveTask.MEAN = StatTask.MEAN
saveTask.STDDEV = StatTask.STDDEV
saveTask.COVARIANCE = StatTask.COVARIANCE
saveTask.ROI_PIXEL_COUNT = StatTask.ROI_PIXEL_COUNT
saveTask.ROI_COLORS = StatTask.ROI_COLORS
saveTask.ROI_NAMES = StatTask.ROI_NAMES
saveTask.OUTPUT_URI = outFile
saveTask.Execute

; Restore our ROI statistics
restoreTask = ENVITask('XTRestoreROITrainingStatistics')
restoreTask.INPUT_URI = saveTask.OUTPUT_URI
restoreTask.execute

; Run SAM classification
ClassTask = ENVITask('SpectralAngleMapperClassification')
ClassTask.INPUT_RASTER = Raster
ClassTask.MEAN = restoreTask.MEAN
ClassTask.CLASS_NAMES = restoreTask.ROI_NAMES
ClassTask.CLASS_COLORS = restoreTask.ROI_COLORS
ClassTask.Execute

; Get the collection of data objects currently
; available in the Data Manager
DataColl = e.Data

; Add the output to the Data Manager
DataColl.Add, ClassTask.OUTPUT_RASTER

; Display the result
View = e.GetView()
Layer = View.CreateLayer(Raster)
Layer2 = View.CreateLayer(ClassTask.OUTPUT_RASTER)
```