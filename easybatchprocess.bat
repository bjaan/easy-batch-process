@echo off
setlocal EnableExtensions EnableDelayedExpansion

if "%~1" == "" goto usage
if "%~2" == "" goto usage
if "%~3" == "" goto usage
if "%~4" == "" goto usage

set folder_to_search=%~f1
set file_types=%~2
set output_path=%~f3
set template_command=%~4

for /L %%n in (1 1 500) do if "!output_path:~%%n,1!" neq "" set /a "output_path_len=%%n+1"

set /a ID=1

title Searching...

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
  set folder=%%~dpf
  set FileName[!ID!]="!fullpath!"
  set FilePath[!ID!]="!folder!"
  set OutputName[!ID!]="%output_path%\!fullpath:~%output_path_len%!"
  set OutputPath[!ID!]="%output_path%\!folder:~%output_path_len%!"
  set /a ID+=1
)
goto:eof

:processfiles

set /a ID-=1

ECHO Total files found : !ID!

FOR /L %%n IN (1 1 !ID!) DO (
  echo - %%n !FileName[%%n]!
)

FOR /L %%n IN (1 1 !ID!) DO (
  echo Processing %%n of !ID!: !FileName[%%n]!
  title Processing %%n of !ID!: !FileName[%%n]!
  set cmd=!template_command!
  call set "cmd=%%cmd:[IN]=!FileName[%%n]!%%"
  call set "cmd=%%cmd:[INPATH]=!FilePath[%%n]!%%"
  call set "cmd=%%cmd:[OUT]=!OutputName[%%n]!%%"
  call set "cmd=%%cmd:[OUTPATH]=!OutputName[%%n]!%%"
  echo Command: !cmd!
  call set "output_folder=!OutputPath[%%n]!"
  if not exist !output_folder! mkdir !output_folder!
  call !cmd!
)

title Finished.
goto end

:usage
echo Generate a batch processing batch file
echo easybatchprocess.bat folder_to_search file_types output_path command_to_run
echo   folder_to_search: search for files recursively trough this folder: e.g. c:\Temp
echo   file_types: search for filetypes e.g. *.* or *.mkv
echo   output_path: output path for files found: e.g. C:\Temp\Output
echo   command_to_run: template command to execute for each file:
echo      tokens that are replaced: e.g. when file found is C:\Temp\Input\Season1\video1.mkv
echo              [IN] path and file name found: e.g. "C:\Temp\Input\Season1\video1.mkv"
echo              [OUT] fully qualifed output file: output_path + relative path to the folder_to_search + filename: e.g. "C:\Temp\Output\Season1\video1.mkv"
echo              [INPATH] absolute path where the file is found, the full path where the file is found: e.g. C:\Temp\Input\Season1\
echo              [OUTPATH] path where the output file created: output_path + relative path to the folder_to_search: e.g.  C:\Temp\Output\Season1\

:end