;h+
; Copyright (c) 2018, Harris Geospatial Solutions, Inc.
; 
; Licensed under MIT, see LICENSE.txt for more details
;h-

;+
; :Description:
;    Procedure that wraps IDL's file_search function for
;    use in ENVI tasks and the ENVI modeler.
;    
;    This task throws an error if no files are found that 
;    match the search pattern in the directory.
;
;
;
; :Keywords:
;    COUNT: out, required, type=long
;      Returns the total number of files found.
;    DIRECTORY: in, required, type=string
;      Specify the folder you want to search for files.
;    EXCLUDE_EXTENSIONS: in, optional, type=stringarray
;      Specify any file extensions that you want to have 
;      excluded from the results.
;    RECURSIVE: in, optional, type=boolean
;      If set, then the folder will be recursively searched
;      for files. Otherwise, only the files directly in the 
;      folder will be searched for.
;    SEARCH_PATTERN: in, required, type=string
;      Specify the patter for searching for files. Wildcards
;      are accepted as asterisks "*".
;    OUTPUT_FILES: out, required, type=stringarray
;      Contains an array of all the output files from the task.
;
; :Author: Zachary Norman - GitHub: znorman-harris
;-
pro xtFileSearch,$
  COUNT = count,$
  DIRECTORY = directory,$
  EXCLUDE_EXTENSIONS = exclude_extensions,$
  RECURSIVE = recursive,$
  SEARCH_PATTERN = search_pattern,$
  OUTPUT_FILES = output_files
  compile_opt idl2, hidden
  
  ;validate our inputs
  if ~keyword_set(directory) then begin
    message, 'DIRECTORY not specified, required!', LEVEL = -1
  endif
  if ~file_test(directory, /DIRECTORY) then begin
    message, 'DIRECTORY specified, but folder does not exist!', LEVEL = -1
  endif
  if ~keyword_set(search_pattern) then begin
    message, 'SEARCH_PATTERN not specified, required!', LEVEL = -1
  endif
    
  ;check if we are recursive or not
  if keyword_set(recursive) then begin
    output_files = file_search(directory, search_pattern, COUNT = count)
  endif else begin
    ;change dir, search, and add source dir back to files
    cd, directory, CURRENT = first_dir
    output_files = file_search(search_pattern, COUNT = count)
    cd, first_dir
    output_files = directory + path_sep() + output_files
  endelse

  ;throw error if no files
  if (count eq 0) then begin
    message, 'No files found in DIRECTORY that match SEARCH_PATTERN!', LEVEL = -1
  endif
    
  ;check if we have file extensions to exclude
  if keyword_set(exclude_extensions) then begin
    ;init list to hold files
    keep = list()
    
    ;process each file
    foreach file, output_files do begin
      ;init flag if the file is ok or not
      ok = 1
      
      ;process each extension
      foreach ext, exclude_extensions do begin
        if file.endswith(ext) then begin
          ok = 0
          break
        endif
      endforeach
      
      ;save if appropriate
      if (ok) then keep.Add, file
    endforeach
    
    ;update count information
    count = n_elements(count)
    
    ;make sure we found files
    if (count eq 0) then begin
      message, 'No files found after filtering by EXCLUDE_EXTENSIONS!', LEVEL = -1
    endif
    
    ;convert to array
    output_files = keep.toArray()
  endif
end
