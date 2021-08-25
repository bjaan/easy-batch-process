@echo off
setlocal EnableExtensions EnableDelayedExpansion

if "%~1" == "" goto usage
if "%~2" == "" goto usage
if "%~3" == "" goto usage
if "%~4" == "" goto usage

rem path tilde tricks see https://ss64.com/nt/syntax-args.html

set folder_to_search=%~f1
set file_types=%~2
set file_types_2=%~2
set output_path=%~f3
set template_command=%~4
set template_command=%template_command:""="%

for /L %%n in (1 1 500) do if "!folder_to_search:~%%n,1!" neq "" set /a "folder_to_search_len=%%n+1"

set /a "folder_to_search_len=%folder_to_search_len%+1"

set /a ID=1

echo Searching...

:processtypes
FOR /f "tokens=1* delims=;" %%a IN ("%file_types%") DO IF "%%a" NEQ "" (
  SET file_types=%%b
  CALL :processtype %%a
)

IF "%file_types%" NEQ "" goto :processtypes

goto processfiles

:processtype
FOR /f "delims=" %%f IN ('dir /b /s "%folder_to_search%\%1"') DO (
  set fullpath=%%~ff
  echo - !ID! !fullpath:~%folder_to_search_len%!
  set /a ID+=1
)
goto:eof

:processfiles

set /a ID-=1

ECHO Total files found: !ID! - Starting batch...

set /a C=1

:processfiletypes
FOR /f "tokens=1* delims=;" %%a IN ("%file_types_2%") DO IF "%%a" NEQ "" (
  SET file_types_2=%%b
  CALL :processfiletype %%a
)

IF "%file_types_2%" NEQ "" goto :processfiletypes

echo Finished.
goto end

:processfiletype
FOR /f "delims=" %%f IN ('dir /b /s "%folder_to_search%\%1"') DO (
  set fullpath=%%~ff
  set folder=%%~dpf
  set FileName="!fullpath!"
  set FilePath="!folder!"
  set OutputName="%output_path%\!fullpath:~%folder_to_search_len%!"
  set OutputPath="%output_path%\!folder:~%folder_to_search_len%!"
  set FileNameOnly=%%~nxf
  echo Processing !C! of !ID!: !fullpath:~%folder_to_search_len%!
  title Processing !C! of !ID!: !fullpath:~%folder_to_search_len%!
  set cmd=!template_command!
  call set "cmd=%%cmd:[IN]=!FileName!%%"
  call set "cmd=%%cmd:[INPATH]=!FilePath!%%"
  call set "cmd=%%cmd:[OUT]=!OutputName!%%"
  call set "cmd=%%cmd:[OUTPATH]=!OutputName!%%"
  call set "cmd=%%cmd:[INFILE]=!FileNameOnly!%%"
  echo Command: !cmd!
  call set "output_folder=!OutputPath!"
  if not exist !output_folder! mkdir !output_folder!
  call %%cmd%%
  set /a C+=1
)
goto:eof

:usage
echo Generate a batch processing batch file
echo easybatchprocess folder_to_search file_types output_path command_to_run
echo   folder_to_search: search for files recursively trough this folder: e.g. c:\Temp
echo   file_types: search for filetypes e.g. *.* or *.mkv
echo   output_path: output path for files found: e.g. C:\Temp\Output
echo   command_to_run: template command to execute for each file:
echo      tokens that are replaced: e.g. when file found is C:\Temp\Input\Season1\video1.mkv
echo              [IN] path and file name found: e.g. "C:\Temp\Input\Season1\video1.mkv"
echo              [OUT] fully qualifed output file: output_path + relative path to the folder_to_search + filename: e.g. "C:\Temp\Output\Season1\video1.mkv"
echo              [INPATH] absolute path where the file is found, the full path where the file is found: e.g. C:\Temp\Input\Season1\
echo              [OUTPATH] path where the output file created: output_path + relative path to the folder_to_search: e.g.  C:\Temp\Output\Season1\
echo              [INFILE] file name found: e.g. video1.mkv

:end