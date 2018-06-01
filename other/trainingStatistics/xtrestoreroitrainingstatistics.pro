;h+
; Copyright (c) 2018, Harris Geospatial Solutions, Inc.
; 
; Licensed under MIT, see LICENSE.txt for more details
;h-

;+
; :Description:
;    Procedure that restores information from ROI
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
;    IUTPUT_URI: in, required, type=string
;      Fully qualified filepath to a file on disk
;      that contains the ROI statistics.
;
; :Author: Eduardo Iturrate
;-
pro xtRestoreROITrainingStatistics,$
  INPUT_URI = input_uri,$
  MIN = min,$
  MAX = max,$
  MEAN = mean, $
  STDDEV = stddev,$
  COVARIANCE = covariance,$
  ROI_PIXEL_COUNT = roi_pixel_count, $
  ROI_COLORS = roi_colors,$
  ROI_NAMES = roi_names
  compile_opt idl2, hidden

  if (~File_Test(input_uri)) then begin
    return
  endif

  hInfo = Json_Parse(input_uri)
  
  if (~Isa(hInfo, 'Hash')) then begin
    return
  endif

  if (hInfo.HasKey('min')) then begin
    min = hInfo['min']
  endif
  if (hInfo.HasKey('max')) then begin
    max = hInfo['max']
  endif
  if (hInfo.HasKey('mean')) then begin
    mean = hInfo['mean']
  endif
  if (hInfo.HasKey('stddev')) then begin
    stddev = hInfo['stddev']
  endif
  if (hInfo.HasKey('covariance')) then begin
    covariance = hInfo['covariance']
  endif
  if (hInfo.HasKey('roi_pixel_count')) then begin
    roi_pixel_count = hInfo['roi_pixel_count']
  endif
  if (hInfo.HasKey('roi_colors')) then begin
    roi_colors = hInfo['roi_colors']
  endif
  if (hInfo.HasKey('roi_names')) then begin
    roi_names = hInfo['roi_names']
  endif  
end

