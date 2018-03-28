;h+
; Copyright (c) 2018, Harris Geospatial Solutions, Inc.
;h-

;+
;   The purpose of this procedure is to to used to add the tasks stored below this folder into
;   the current session on ENVI
;
;
; :Author: Zachary Norman - GitHub: znorman-harris
;-
pro xtTasksInit
  compile_opt idl2, hidden
  on_error, 2

  ;get current directory
  thisfilename = routine_filepath()
  thisdir = file_dirname(thisfilename)

  ;get current session of ENVI
  e = envi(/current)
  if (e eq !NULL) then begin
    message, 'ENVI has not been started yet, requried!'
  endif

  ;if we aren't looking for help, then let's find all of the task files
  taskFiles = file_search(thisdir, '*.task', COUNT = nTasks)
  
  ;make sure we have tasks or return
  if (ntasks eq 0) then return
  
  ;process each file
  foreach taskFile, taskFiles do begin
    ;skip any errors
    catch, err
    if (err ne 0) then begin
      help, /LAST_MESSAGE
      catch, /CANCEL
      continue
    endif

    ;try to create a task so ENVI knows about the tools
    task = ENVITask(taskFile)
  endforeach
  catch, /CANCEL
end
