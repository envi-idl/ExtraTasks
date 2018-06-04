;h+
; Copyright (c) 2018, Harris Geospatial Solutions, Inc.
; 
; Licensed under MIT, see LICENSE.txt for more details
;h-

;+
; :Description:
;    Routine that allows users to execute any IDL
;    statement in an ENVI task and the ENVI modeler.
;    
;    This task does not return anything while running.
;
;
;
; :Keywords:
;    STATEMENT: in, required, type=string
;      Specify an IDL statement that you want to execute
;      as a task.
;
; :Author: Zachary Norman - GitHub: znorman-harris
;-
pro xtExecuteStatement,$
  STATEMENT = statement
  compile_opt idl2, hidden

  ;validate the input
  if (statement eq !NULL) then begin
    message, 'STATEMENT not specified, required!', LEVEL = -1
  endif
  if ~isa(statement, /STRING) then begin
    message, 'STATEMENT specified, but is not a string!', LEVEL = -1
  endif

  ;execute the line
  if ~execute(statement) then begin
    help, /LAST_MESSAGE
    print
    message, 'Error while executing statement!', LEVEL = -1
  endif
end
