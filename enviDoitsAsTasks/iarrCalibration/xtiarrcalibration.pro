;h+
; Copyright (c) 2018, Harris Geospatial Solutions, Inc.
; 
; Licensed under MIT, see LICENSE.txt for more details
;h-
;+
; :Description:
;    Performs IARR Calibration on the input raster. See the 
;    documentation for more information on the algorithm.
;
;
;
; :Keywords:
;    INPUT_RASTER: in, required, type=ENVIRaster
;      Specify the raster to process.
;    OUTPUT_RASTER_URI: in, optional, type=strin
;      Optionally specify the fully-qualified filepath
;      to the output raster.
;
; :Author: Zachary Norman - GitHub:znorman-harris
;-
pro xtIARRCalibration,$
  INPUT_RASTER = input_raster,$
  OUTPUT_RASTER_URI = output_raster_uri
  compile_opt idl2
  
  ;get current ENVI
  e = envi(/CURRENT)
  if (e eq !NULL) then begin
    message, 'ENVI has not started yet, requried!
  endif
  
  ;make sure we have a raster
  if (input_raster eq !NULL) then begin
    message, 'INPUT_RASTER not specified, requred!'
  endif
  
  ;specify output filename if not provided
  if (output_raster_uri eq !NULL) then begin
    output_raster_uri = e.GetTemporaryFilename()
  endif
  
  ;get stats on our raster
  stats = ENVIRasterStatistics(input_raster)
  
  ; Get FIDs for input rasters
  raster_fid = ENVIRasterToFID(input_raster)
  
  ; Perform IARR calibration for each file
  ENVI_File_Query, raster_fid, DIMS=dims, NB=nb
  
  ;cal the calibration doit
  ENVI_Doit,'ENVI_Cal_Doit',$
    FID = raster_fid,$
    DIMS = dims,$
    POS = lindgen(nb), $
    MEAN = stats.MEAN,$
    DSTR = 'IARR Calibration',$
    OUT_NAME = output_raster_uri,$
    R_FID = output_raster_fid
end
