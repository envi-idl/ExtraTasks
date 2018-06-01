;h+
; (c) 2018 Harris Geospatial Solutions, Inc.
;
; Licensed under MIT, see LICENSE.txt for more details.
;h-


;+
;
;  IDL main level program that will compile the code present into a single IDL
;  SAVE file called the xttasksinit.sav. This will also place the task files next to
;  the compiled source code.
;
;  This is only necessary if you are trying to use the UAV Toolkit without IDL
;  or with the enterprise version of ENVI/IDL.
;
;  Just press compile + run in the IDL workbench to build the IDL SAVE file.
;
;  The output directory will be called "ExtraTasks-build" in your system temporary
;  folder. This helps avoid any conflicts on IDL's search path. If you
;  dont know where this folder exist on your machine, it will print to the
;  IDL console once finished.
;
;
; :Author: Zachary Norman - GitLab: znorman-harris
;-


;get this source directory
thisDir = file_dirname(routine_filepath())

;set up our output location
outDir = filepath('', /TMP) + 'ExtraTasks-build'
if ~file_test(outDir, /DIRECTORY) then file_mkdir, outDir

;search for PRO files
files = file_search(thisDir, '*.pro', COUNT = nPro)

;validate
if (nPro eq 0) then begin
  message, 'No PRO files found in this source directory, where did they go?'
endif

;array of files to exclude form the build
exclude = ['xttasksinit_build']

;start child process
bdg = idl_idlbridge()

;compile each file
foreach file, files do begin
  ;skip conditions
  if (total(strlowcase(file_basename(file)) eq exclude) gt 0) then continue
  if file.endswith('.spec.pro') then continue
  bdg.execute, '.compile "' + file + '"'
endforeach

;resolve dependencies
bdg.execute, 'resolve_all, /CONTINUE_ON_ERROR, SKIP_ROUTINES = ["envi", "envi_doit"]'

;save routines and clean up
bdg.execute, 'save, /ROUTINES, FILENAME = "' + outDir + path_sep() + 'xttasksinit.sav"'
obj_destroy, bdg

;copy task files
taskFiles = file_search(thisDir, '*.task', COUNT = nTask)
if (nTask gt 0) then file_copy, taskFiles, outDir, /OVERWRITE

;alert user of output location
print, 'Build located at : ' + outDir
end