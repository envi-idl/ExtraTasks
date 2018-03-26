
; This task is useful if the name property from the raster contains characters that are not filename-friendly.

pro ExtractNameFromRaster, $
  INPUT_RASTER=inputRaster, $  
  OUTPUT_STRING=outputString
  compile_opt idl2, hidden

  outputString = inputRaster.name

  ; ' ' is technically a valid filename character but for this case we 
  ; decided to remove it as well.
  
  invalidChars = ['\', '/', '>', '<', ':', '"', '|', '?', '*', ' ']
  foreach invalidChar, invalidChars do begin
    outputString = outputString.Replace(invalidChar, '_')    
  endforeach  
end 