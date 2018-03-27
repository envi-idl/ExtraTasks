# Other Tasks

A collection of other, miscellaneous tasks for ENVI.

These examples assume that you have not placed the tasks in ENVI's custom code folder and are running from IDL with this repository added to IDL's search path. For the proper way to install the tasks, see [https://github.com/envi-idl/TaskAndExtensionInstallGuide](https://github.com/envi-idl/TaskAndExtensionInstallGuide).

For specific details about all task parameters for the tasks listed below, view the associated **.task** file in this folder.

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