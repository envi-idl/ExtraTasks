;h+
; Copyright (c) 2018, Harris Geospatial Solutions, Inc.
; 
; Licensed under MIT, see LICENSE.txt for more details
;h-

;+
; :Description:
;    Simple procedure that generates an ENVI 
;    pyramid file for an image.
;    
;    See examples.md for how to call this.
;
;
;
; :Keywords:
;    INPUT_RASTER: in, required, type=ENVIRaster
;      Specify the raster you want to generate a Pyramid 
;      file for.
;    INCLUDE_FULL_RESOLUTION: in, optional, type=boolean
;      Set this to include the full-resolution data in the
;      pyramid file.
;
; :Author: Eduardo Iturrate
;-
pro xtCreateRasterPyramid,$
  INPUT_RASTER = inputRaster, $
  INCLUDE_FULL_RESOLUTION = includeFullResolution
  compile_opt idl2, hidden
  
  inputRaster.CreatePyramid, INCLUDE_FULL_RESOLUTION=includeFullResolution
end
