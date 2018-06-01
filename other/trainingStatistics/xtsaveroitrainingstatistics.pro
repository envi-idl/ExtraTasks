;h+
; Copyright (c) 2018, Harris Geospatial Solutions, Inc.
; 
; Licensed under MIT, see LICENSE.txt for more details
;h-

;+
; :Description:
;    Procedure that saves information from ROI
;    training statistics to a file on disk.
;    
;    See examples.md for how to call this routine.
;
;
; :Keywords:
;    MIN: in, optional, type=arr
;    MAX: in, optional, type=arr
;    MEAN: in, optional, type=arr
;    STDDEV: in, optional, type=arr
;    COVARIANCE: in, optional, type=arr
;    ROI_PIXEL_COUNT: in, optional, type=arr
;    ROI_COLORS: in, optional, type=arr
;    ROI_NAMES: in, optional, type=arr
;    OUTPUT_URI: in, required, type=string
;      Fully qualified filepath to a file on disk
;      that will contain the ROI statistics.
;
; :Author: Eduardo Iturrate
;-
pro xtSaveROITrainingStatistics,$
  MIN = min,$
  MAX = max,$
  MEAN = mean,$
  STDDEV = stddev, $
  COVARIANCE = covariance,$
  ROI_PIXEL_COUNT = roi_pixel_count,$
  ROI_COLORS = roi_colors, $
  ROI_NAMES = roi_names,$
  OUTPUT_URI = output_uri
  compile_opt idl2, hidden

  hInfo = Hash(/FOLD_CASE)
  
  if (N_Elements(min) gt 0) then begin
    hInfo['min'] = min    
  endif
  if (N_Elements(max) gt 0) then begin
    hInfo['max'] = max
  endif
  if (N_Elements(mean) gt 0) then begin
    hInfo['mean'] = mean
  endif
  if (N_Elements(stddev) gt 0) then begin
    hInfo['stddev'] = stddev
  endif
  if (N_Elements(covariance) gt 0) then begin
    hInfo['covariance'] = covariance
  endif
  if (N_Elements(roi_pixel_count) gt 0) then begin
    hInfo['roi_pixel_count'] = roi_pixel_count
  endif
  if (N_Elements(roi_colors) gt 0) then begin
    hInfo['roi_colors'] = roi_colors
  endif
  if (N_Elements(roi_names) gt 0) then begin
    hInfo['roi_names'] = roi_names
  endif
  
  if (N_Elements(output_uri) eq 0) then begin
    output_uri = ENVI.GetTemporaryFilename('.json')
  endif
  
  ;write to disk
  OpenW, lun, output_uri, /GET_LUN
  printF, lun, json_serialize(hInfo), /IMPLIED_PRINT
  Free_Lun, lun  
end

