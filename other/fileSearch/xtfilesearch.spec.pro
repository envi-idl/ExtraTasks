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
taskFile = thisdir + path_sep() + 'xtfilesearch.task'
proFile = thisdir + path_sep() + 'xtfilesearch.pro'

;start ENVI
e = envi(/HEADLESS)

;create a luna tester
l = luna(CONFIG_FILE = './../../idl.test.json')

  ;create a suite
  s = l.suite('Test that our task file')

    ;create a test
    it = s.test('exists')

      (it.expects(1)).toEqual, file_test(taskFile)

    it = s.test('is a valid task file')

      (it.expects(taskFile)).toBeAValidENVITask

  ;create a suite
  s = l.suite('Test that we')
  
    ;create a test
    it = s.test('can search for files with the procedure')
    
      (it.expects('xtfilesearch')).toRunProcedure, $
        COUNT = count,$
        DIRECTORY = thisdir,$
        SEARCH_PATTERN = '*.pro',$
        OUTPUT_FILES = output_files

    ;create a test
    it = s.test('and that files returned are correct')

      (it.expects(output_files)).ToEqual, [proFile, proFile.replace('.pro', '.spec.pro')]
      (it.expects(count)).ToEqual, 2

    ;create a test
    it = s.test('can search for files with the task')

      ; create a task
      task = ENVITask(taskFile)
      task.DIRECTORY = thisdir
      task.SEARCH_PATTERN = '*.pro'

      (it.expects(task)).ToExecuteENVITask

    ;create a test
    it = s.test('and that files returned are correct')

      (it.expects(task.OUTPUT_FILES)).ToEqual, [proFile, proFile.replace('.pro', '.spec.pro')]
      (it.expects(task.COUNT)).ToEqual, 2


    ;create a test
    it = s.test('can search for files with the procedure while exlcuding extensions')
    
      (it.expects('xtfilesearch')).toRunProcedure, $
        COUNT = count,$
        DIRECTORY = thisdir,$
        SEARCH_PATTERN = '*.pro',$
        EXCLUDE_EXTENSIONS = ['.spec.pro'],$
        OUTPUT_FILES = output_files

    ;create a test
    it = s.test('and that files returned are correct')

      (it.expects(output_files)).ToEqual, [proFile]
      (it.expects(count)).ToEqual, 1

    ;create a test
    it = s.test('can search for files with the task while exlcuding extensions')

      ; create a task
      task = ENVITask(taskFile)
      task.DIRECTORY = thisdir
      task.SEARCH_PATTERN = '*.pro'
      task.EXCLUDE_EXTENSIONS = '.spec.pro'

      (it.expects(task)).ToExecuteENVITask

    ;create a test
    it = s.test('and that files returned are correct')

      (it.expects(task.OUTPUT_FILES)).ToEqual, [proFile]
      (it.expects(task.COUNT)).ToEqual, 1
  
;generate a test summary
l.GenerateTestSummary
end