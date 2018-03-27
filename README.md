# ExtraTasks

A collection of additional tasks for ENVI that don't belong to other GitHub repositories. These tasks are not constrained to a specific example or use case.

All of these tasks (names and display names) are prefixed with **XT** (for extra) to denote that they belong to this repository.


## Requirements

Most of these tasks require the latest version of ENVI (5.5) to run. Some may work on older versions, but it is not guaranteed.

## Installation

To install the tasks, visit our installation guide [https://github.com/envi-idl/TaskAndExtensionInstallGuide](https://github.com/envi-idl/TaskAndExtensionInstallGuide).

Alternatively, if you are going to be running the tasks directly from IDL, you can add the following line to the beginning of your scripts to have ENVI auto-discover the tasks after updating IDL's search path. Note that, if you do not follow the installation guide above, these tasks wil **only** be avaiable after you call this procedure.

```idl
;load the tasks we have in this directory
xtTasksInit
```

## Tasks

Here is a summary (by directory) of what tasks are avaiable. To access


### enviDoitsAsTasks

**NOTE: These require ENVI 5.5 or newer to run**

See [./enviDoitsAsTasks/examples.md](./enviDoitsAsTasks/examples.md) for examples running each task from IDL

This folder contains ENVI doits that have been wrapped as tasks. Here are the tasks:

- XTBufferZoneTask: This task wraps the ENVI Classic buffer zone doit, which generates an image where the pixel values represent the pixel distance to the closest pixel of a specified class of a classification image.

- XTClassicISODATAClassification: This task wraps the ENVI Classic version of ISODATAClassification which has some different parameters compared to the newer ISODATAClassificaton task.


### Image Transforms

**NOTE: These require ENVI 5.5 or newer to run**

See [./imageTransforms/examples.md](./imageTransforms/examples.md) for examples running each task from IDL.

Several ENVI Tasks that wrap the ENVI doits for converting between color spaces. Here are the tasks:

- XTHLStoRGBRaster: This tasks wraps the ENVI Classic `rgb_itrans_doit` and converts an image from hue/lightness/saturation (HLS) to red/green/blue (RGB).

- XTHSVtoRGBRaster: This tasks wraps the ENVI Classic `rgb_itrans_doit` and converts an image from hue/saturation/value (HSV) to red/green/blue (RGB).

- XTRGBtoHLSRaster: This tasks wraps the ENVI Classic `rgb_trans_doit` and converts an image from red/green/blue (RGB) to hue/lightness/saturation (HLS).

- XTRGBtoHSVRaster: This tasks wraps the ENVI Classic `rgb_trans_doit` and converts an image from red/green/blue (RGB) to hue/lightness/saturation (HLS).


## Other

**NOTE: These require ENVI 5.5 or newer to run**

See [./other/examples.md](./other/examples.md) for examples running each task from IDL.

- XTExtractNameFromRaster: Simple procedure that returns the name of a raster with special characters removed so that you could write a new file to disk. The special characters that get removed are ones that are not allowed in filepaths on computers and can appear in some use cases. 


## License

Licensed under MIT. See LICENSE.txt for additional details and information.

Copyright (c) 2017, Harris Geospatial Solutions, Inc.
