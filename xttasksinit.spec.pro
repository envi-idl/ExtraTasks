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
;
; :Author: Zachary Norman - GitHub: znorman-harris
;-


;get the current directory
thisdir = file_dirname(routine_filepath())

;start ENVI
e = envi(/HEADLESS)

;create a luna tester
l = luna(CONFIG_FILE = './idl.test.json')

  ;create a suite
  s = l.suite('Test that our tasks')
  
    ;create a test
    it = s.test('can be created')
    
      ;search for files
      files = file_search(thisdir, '*.task', COUNT = nFiles)
      
      ;make sure we have files and open all tasks
      if (nFiles gt 0) then begin
        foreach file, files do (it.expects(file)).toBeAValidENVITask
      endif

  
;generate a test summary
l.GenerateTestSummary
end