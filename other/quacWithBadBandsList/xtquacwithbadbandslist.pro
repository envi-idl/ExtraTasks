;h+
; Copyright (c) 2018, Harris Geospatial Solutions, Inc.
; 
; Licensed under MIT, see LICENSE.txt for more details
;h-

;+
; :Description:
;    Procedure that allows you to provide information
;    on the bands in a raster that should be excluded
;    when running QUAC. The raster that is returned will
;    not include the bands that should be ignored.
;    
;    To specify the bands that are to be skipped there are 
;    two options: an array or a file. For both cases, you must
;    have the same number of items as there are bands in
;    the raster.
;
;
;
; :Keywords:
;    INPUT_BAD_BANDS_ARRAY: in, optional, type=bytarr
;      Specify an array of 1/0 values for bands to keep
;      or disregard. If this is not set, then INPUT_BAD_BANDS_URI
;      must be set.
;    INPUT_BAD_BANDS_URI: in, optional, type=string
;      Specify the fully-qualified filepath to a file on disk
;      where each line has a 1/0 for bands to keep or disregard. 
;      If this is not set, then INPUT_BAD_BANDS_ARRAY must be.
;      must be set.
;    INPUT_RASTER: in, required, type=ENVIRaster
;      Specify the raster that you want to process.
;    OUTPUT_RASTER_URI: in, optional, type=string
;      Optionally specify the output filepath for where the output
;      raster will be generated on disk. If not set, then a temporary
;      filename will be generated.
;    SENSOR: in, optional, type=string
;      Specify the type of sensor that collected the data. Used
;      for QUAC. See the documentation or the task file for details on
;      what sensors this can be set to.
;
; :Author: Zachary Norman - GitHub: znorman-harris
;-
pro xtQuacWithBadBandsList,$
  INPUT_BAD_BANDS_ARRAY = input_bad_bands_array,$
  INPUT_BAD_BANDS_URI = input_bad_bands_uri,$
  INPUT_RASTER = input_raster,$
  OUTPUT_RASTER_URI = output_raster_uri,$
  SENSOR = sensor
  compile_opt idl2, hidden
  
  ;get current session of ENVI
  e = envi(/CURRENT)
  
  ;validate inputs
  if ~keyword_set(input_bad_bands_array) then begin
    if ~keyword_set(input_bad_bands_uri) then begin
      message, 'INPUT_BAD_BANDS_URI not specified, required!', LEVEL = -1
    endif
    if ~file_test(input_bad_bands_uri) then begin
      message, 'INPUT_BAD_BANDS_URI specified, but does not exist!', LEVEL = -1
    endif
    
    ;read and validate our text file
    nLines = file_lines(input_bad_bands_uri)

    ;make sure we have lines
    if (nLines eq 0) then begin
      message, 'INPUT_BAD_BANDS_URI exists, but is an empty file!', LEVEL = -1
    endif

    ;init and ingest
    strings = strarr(nLines)
    openr, lun, input_bad_bands_uri, /GET_LUN
    readf, lun, strings
    free_lun, lun

    ;find lines that are not empty
    idxOk = where(strtrim(strings,2) ne '', countOk)
    if (countOk eq 0) then begin
      message, 'INPUT_BAD_BANDS_URI exists, but only contains empty lines!', LEVEL = -1
    endif

    ;make sure we have the same number of lines as bands
    if (countOk ne input_raster.NBANDS) then begin
      message, 'INPUT_BAD_BANDS_URI does not have the same number of lines as bands!', LEVEL = -1
    endif

    ;subset to OK lines and convert to numbers
    input_bad_bands_array = long(strings[idxOk])
  endif else begin
    if ~isa(input_bad_bands_array, /ARRAY) then begin
      message, 'INPUT_BAD_BANDS_URI specified, but it is not an array!', LEVEL = -1
    endif
  endelse

  if ~keyword_set(input_raster) then begin
    message, 'INPUT_RASTER not specified, required!', LEVEL = -1
  endif
  if ~isa(input_raster, 'enviraster') then begin
    message, 'INPUT_RASTER specified, but is not an ENVIRaster!', LEVEL = -1
  endif
  
  ;find the OK bands
  idxOk = where(input_bad_bands_array, countOk)
  if (countOk eq 0) then begin
    message, 'INPUT_BAD_BANDS does not contain any bands to include for processing!', LEVEL = -1
  endif
  
  ;subset our raster
  subset = ENVISubsetRaster(input_raster, BANDS = idxOk)
  
  ;check if we specified our output keyword
  if ~keyword_set(output_raster_uri) then begin
    output_raster_uri = e.GetTemporaryFilename()
  endif
  
  ;run QUAC
  quacTask = ENVITask('QUAC')
  quacTask.INPUT_RASTER = subset
  if keyword_set(sensor) then quactask.SENSOR = sensor
  quacTask.OUTPUT_RASTER_URI = output_raster_uri
  quacTask.execute
  
  ;clean up
  subset.close
end