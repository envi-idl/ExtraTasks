# ENVI doits as Tasks

Here are some example code snippets for how to run these tasks from IDL. 

These examples assume that you have not placed the tasks in ENVI's custom code folder and are running from IDL with this repository added to IDL's search path. For the proper way to install the tasks, see [https://github.com/envi-idl/TaskAndExtensionInstallGuide](https://github.com/envi-idl/TaskAndExtensionInstallGuide).

For specific details about all task parameters for the tasks listed below, view the associated **.task** file in this folder.


## XTBufferZone

This task wraps the ENVI Classic buffer zone doit, which generates an image where the pixel values represent the pixel distance to the closest pixel of a specified class of a classification image. The general steps for this task are:

1. Generate a classification image.
2. Generate a buffer image.
3. Create a new classification image from the buffer.
4. (Optional) perform any classification cleanup steps (aggregation, sieving, smoothing)

The workflow specified above is similar to using the IDL routine `morph_distance` and produces similar results. Here is an example that does the following:

1. Creates an approximate water mask
2. Calculates a buffer zone
3. Use color slice classification to grow our mask
4. Display the results

Note the order of the layers:

- Buffer zone image
- Original raster
- Grown mask colored red
- Original mask colored blue

```idl
; Start the application
e = ENVI()

; Load our extra tasks
xtTasksInit

; Open an input file
File = Filepath('qb_boulder_msi', Subdir=['data'], $
  Root_Dir=e.Root_Dir)
Raster = e.OpenRaster(File)

; Calculate a spectral index
siRaster = ENVISpectralindexRaster(Raster, 'Normalized Difference Vegetation Index')

; Create an approximate classification image of the water in our scene
; This will contain holes and speckling in the lake for our scene
classTask = ENVITask('ColorSliceClassification')
classTask.INPUT_RASTER = siRaster
classTask.CLASS_RANGES = [-1, -0.15]
classTask.CLASS_NAMES = 'Water'
classTask.CLASS_COLORS = [[0, 0, 255]]
classTask.execute

; Create a buffer image
bufferTask = ENVITask('XTBufferZone')
bufferTask.INPUT_RASTER = classTask.OUTPUT_RASTER
bufferTask.CLASS_VALUES = 1 ; From  our color slice classification image
bufferTask.OUTPUT_DATA_TYPE = 'Integer'
bufferTask.Execute

; Create a new classification image, growing our original image by 5 pixels
; The regions will be larger than the original and holes will be filled in 
; You will also see some false-positives grow larger
classTask2 = ENVITask('ColorSliceClassification')
classTask2.INPUT_RASTER = bufferTask.OUTPUT_RASTER
classTask2.CLASS_RANGES = [0, 5]
classTask2.CLASS_NAMES = 'Water'
classTask2.CLASS_COLORS = [[255, 0, 0]]
classTask2.execute

; Get the collection of data objects currently available in the Data Manager
DataColl = e.Data

; Add the output to the Data Manager
DataColl.Add, bufferTask.OUTPUT_RASTER
DataColl.Add, classTask.OUTPUT_RASTER
DataColl.Add, classTask2.OUTPUT_RASTER

; Display the result
View1 = e.GetView()
Layer1 = View1.CreateLayer(bufferTask.OUTPUT_RASTER)
Layer2 = View1.CreateLayer(Raster)
Layer3 = View1.CreateLayer(classTask2.OUTPUT_RASTER)
Layer4 = View1.CreateLayer(classTask.OUTPUT_RASTER)
```

## XTClassicISODATAClassification

This task wraps the ENVI Classic version of ISODATAClassification which has some different parameters compared to the newer ISODATAClassificaton task.

```idl
; Start the application
e = ENVI()

; Load our extra tasks
xtTasksInit

; Open an input file
File = Filepath('qb_boulder_msi', Subdir=['data'], $
  Root_Dir=e.Root_Dir)
Raster = e.OpenRaster(File)

; run ENVI Classif ISODATAClassification
Task = ENVITask('XTClassicISODATAClassification')
Task.INPUT_RASTER = Raster
Task.MINIMUM_CLASSES = 5
Task.MAXIMUM_CLASSES = 10
Task.STDEV_SPLIT = 0.5
Task.ITERATIONS = 5
Task.execute

; Get the collection of data objects currently available in the Data Manager
DataColl = e.Data

; Add the output to the Data Manager
DataColl.Add, Task.OUTPUT_RASTER

; Display the result
View1 = e.GetView()
Layer1 = View1.CreateLayer(Raster)
Layer2 = View1.CreateLayer(Task.OUTPUT_RASTER)
```