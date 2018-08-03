;h+
; Copyright (c) 2018, Harris Geospatial Solutions, Inc.
;
; Licensed under MIT, see LICENSE.txt for more details
;h-

;+
; :Description:
;    Tests for the xtfilesearch procedure and task.
;    
;    Running these tests requires additional code that
;    is not a part of this repository.
;
; :Author: Zachary Norman - GitHub: znorman-harris
;-


;get the current directory
thisdir = file_dirname(routine_filepath())

;specify the task and PRO file
taskFile = thisdir + path_sep() + 'xtquacwithbadbandslist.task'
proFile = thisdir + path_sep() + 'xtquacwithbadbandslist.pro'

;start ENVI
e = envi(/HEADLESS)

; Open an input file
File = Filepath('qb_boulder_msi', Subdir=['data'], $
  Root_Dir=e.Root_Dir)
Raster = e.OpenRaster(File)

;specify the bad bands array
bad_bands = [1,1,0,1]
nBad = n_elements(bad_bands)

; create a file for the bad bands list
bad_bands_uri = e.getTemporaryFilename('.txt')
openw, lun, bad_bands_uri, /GET_LUN
printf, lun, strtrim(bad_bands,2), /IMPLIED_PRINT
free_lun, lun

;create a luna tester
l = luna(CONFIG_FILE = './../../idl.test.json')

  ;create a suite
  s = l.suite('Test that our task file')

    ; make sure the task exist
    it = s.test('exists')

      (it.expects(1)).toEqual, file_test(taskFile)

    ; make sure we have a valid task file
    it = s.test('is a valid task file')

      (it.expects(taskFile)).toBeAValidENVITask

  ;create a suite
  s = l.suite('Test that we can')
  
    ;create a test
    it = s.test('process with an array using the procedure')

      ; run procedure
      (it.expects('xtQuacWithBadBandsList')).toRunProcedure, $
        INPUT_BAD_BANDS_ARRAY = bad_bands,$
        INPUT_RASTER = Raster,$
        OUTPUT_RASTER_URI = output_raster_uri,$
        SENSOR = 'Generic / Unknown Sensor'

      ; open our output raster
      output_raster = e.openRaster(temporary(output_raster_uri))

    ; validate output raster
    it = s.test('and that we have the right number of bands')

      (it.expects(output_raster.NBANDS)).toEqual, 3

      ; clean up
      output_raster.close

    ;create a test
    it = s.test('process with a file using the procedure')
    
      ; run procedure
      (it.expects('xtQuacWithBadBandsList')).toRunProcedure, $
        INPUT_BAD_BANDS_URI = bad_bands_uri,$
        INPUT_RASTER = Raster,$
        OUTPUT_RASTER_URI = output_raster_uri,$
        SENSOR = 'Generic / Unknown Sensor'

      ; open our output raster
      output_raster = e.openRaster(temporary(output_raster_uri))

    it = s.test('and that we have the right number of bands')

      (it.expects(output_raster.NBANDS)).toEqual, 3

      ; clean up
      output_raster.close

  ;create a suite
  s = l.suite('Test that we can')
  
    ;create a test
    it = s.test('process with an array using the task')

      ; create the task
      task = ENVITask(taskFile)
      task.INPUT_BAD_BANDS_ARRAY = bad_bands
      task.INPUT_RASTER = Raster
      task.SENSOR = 'Generic / Unknown Sensor'

      ; make sure it works
      (it.expects(task)).ToExecuteENVITask

    it = s.test('and that we have the right number of bands')

      (it.expects(task.output_raster.nbands)).toEqual, 3

    ;create a test
    it = s.test('process with a file using the task')

      ; create the task
      task = ENVITask(taskFile)
      task.INPUT_BAD_BANDS_URI = bad_bands_uri
      task.INPUT_RASTER = Raster
      task.SENSOR = 'Generic / Unknown Sensor'

      ; make sure it works
      (it.expects(task)).ToExecuteENVITask

    it = s.test('and that we have the right number of bands')

      (it.expects(task.output_raster.nbands)).toEqual, 3

;clean up
file_delete, bad_bands_uri

;generate a test summary
l.GenerateTestSummary
end