;h+
; Copyright (c) 2018, Harris Geospatial Solutions, Inc.
;
; Licensed under MIT, see LICENSE.txt for more details
;h-

;+
; :Description:
;    Tests for the xtexecutestatement procedure and task.
;    
;    Running these tests requires additional code that
;    is not a part of this repository.
;
; :Author: Zachary Norman - GitHub: znorman-harris
;-

;get the current directory
thisdir = file_dirname(routine_filepath())

;specify the task and PRO file
taskFile = thisdir + path_sep() + 'xtexecutestatement.task'
proFile = thisdir + path_sep() + 'xtexecutestatement.pro'

;start ENVI
e = envi(/HEADLESS)

;create a luna tester
l = luna(CONFIG_FILE = './../../idl.test.json')

  ;create a suite
  s = l.suite('Test that our task file')

    ; amke sure the task exist
    it = s.test('exists')

      (it.expects(1)).toEqual, file_test(taskFile)

    ; make sure we have a valid task file
    it = s.test('is a valid task file')

      (it.expects(taskFile)).toBeAValidENVITask

  ;create a suite
  s = l.suite('Test that we can')
  
    ;validate procedure
    it = s.test('run as a procedure')

      ; run procedure
      (it.expects('xtExecuteStatement')).toRunProcedure, $
        STATEMENT = 'print, 5'

    ; validate our task
    it = s.test('run as a task')

      task = ENVITask(taskFile)
      task.STATEMENT = 'print, 5'
      
      (it.expects(task)).toExecuteENVITask

;generate a test summary
l.GenerateTestSummary
end