;h+
; Copyright (c) 2018, Harris Geospatial Solutions, Inc.
; 
; Licensed under MIT, see LICENSE.txt for more details
;h-
;+
; :Description:
;    Simple procedure that returns the name of a raster with
;    special characters removed so that you could write a new
;    file to disk. The special characters that get removed are 
;    ones that are not allowed in filepaths on computers and can
;    appear in some use cases. 
;
;
;
; :Keywords:
;    INPUT_RASTER: in, required, type=ENVIRaster
;      Specify the raster that you want the name from.
;    OUTPUT_STRING: out, requried, type=string
;      Set this to a named variable that will contain the
;      name of the `INPUT_RASTER` with all special characters
;      removed.
;
; :Author: Eduardo Iturate
;-
pro xtExtractNameFromRaster, $
  INPUT_RASTER = input_raster, $  
  OUTPUT_STRING = output_string
  compile_opt idl2, hidden
  
  ;specify the character that we want to replace invalid characters with
  replaceChar = '_'
  
  ;get the name of our input raster
  output_string = input_raster.name

  ; specify an array of characters that we want to replace
  ; ' ' is technically a valid filename character but for this case we
  ; decided to remove it as well.
  invalidChars = ['\', '/', '>', '<', ':', '"', '|', '?', '*', ' ']
  
  ;replace invalid characters
  foreach invalidChar, invalidChars do begin
    output_string = output_string.Replace(invalidChar, replaceChar)    
  endforeach  
end 
