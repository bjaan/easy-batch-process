@echo off
setlocal EnableExtensions EnableDelayedExpansion

if "%~1" == "" goto usage
if "%~2" == "" goto usage
if "%~3" == "" goto usage
if "%~4" == "" goto usage

rem path tilde tricks see https://ss64.com/nt/syntax-args.html

set folder_to_search=%~f1
set files_to_search=%~2
set files_to_search_2=%~2
set output_path=%~f3
set template_command=%~4
set template_command=%template_command:""="%
set output_redirect=%~5
IF "%~5"=="" set output_redirect=CON

for /L %%n in (1 1 500) do if "!folder_to_search:~%%n,1!" neq "" set /a "folder_to_search_len=%%n+1"

set /a "folder_to_search_len=%folder_to_search_len%+1"

set /a ID=1

echo Searching...
title Searching...

:processtypes
FOR /f "tokens=1* delims=;" %%a IN ("%files_to_search%") DO IF "%%a" NEQ "" (
  SET files_to_search=%%b
  CALL :processtype %%a
)

IF "%files_to_search%" NEQ "" goto :processtypes

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
FOR /f "tokens=1* delims=;" %%a IN ("%files_to_search_2%") DO IF "%%a" NEQ "" (
  SET files_to_search_2=%%b
  CALL :processfiletype %%a
)

IF "%files_to_search_2%" NEQ "" goto :processfiletypes

echo Finished.
title Finished.
goto end

:processfiletype
FOR /f "delims=" %%f IN ('dir /b /s "%folder_to_search%\%1"') DO (
  set fullpath=%%~ff
  set folder=%%~dpf
  set parentfolder=%%~dpf
  set parentfolder=!parentfolder:~0,-1!
  for %%P in (!parentfolder!) do set parentfolder=%%~nxP
  set FileName="!fullpath!"
  set FilePath="!folder!"
  set ParentFolderName=!parentfolder!
  set OutputName="%output_path%\!fullpath:~%folder_to_search_len%!"
  set OutputPath=%output_path%\!folder:~%folder_to_search_len%!
  set FileNameOnly=%%~nxf
  set FileNameNameOnly=%%~nf
  title Processing !C! of !ID!: !fullpath:~%folder_to_search_len%!
  set cmd=!template_command!
  call set "cmd=%%cmd:[IN]=!FileName!%%"
  call set "cmd=%%cmd:[INPATH]=!FilePath!%%"
  call set "cmd=%%cmd:[INPARENT]=!ParentFolderName!%%"
  call set "cmd=%%cmd:[OUT]=!OutputName!%%"
  call set "cmd=%%cmd:[OUTPATH]=!OutputPath!%%"
  call set "cmd=%%cmd:[INFILE]=!FileNameOnly!%%"
  call set "cmd=%%cmd:[INNAME]=!FileNameNameOnly!%%"
  call set "cmd=%%cmd:[INROOT]=!folder_to_search!%%"
  call set "cmd=%%cmd:[OUTROOT]=!output_path!%%"
  call set "output_folder=!OutputPath!"
  if not exist "!output_folder!" mkdir !output_folder!
  set output=!output_redirect!
  if "!output_redirect!" NEQ "CON" (
    if "!output_redirect!"=="TXT" ( set output="[OUTPATH][INNAME].txt" )
    call set "output=%%output:[IN]=!FileName!%%"
    call set "output=%%output:[INPATH]=!FilePath!%%"
    call set "output=%%output:[INPARENT]=!ParentFolderName!%%"
    call set "output=%%output:[OUT]=!OutputName!%%"
    call set "output=%%output:[OUTPATH]=!OutputPath!%%"
    call set "output=%%output:[INFILE]=!FileNameOnly!%%"
    call set "output=%%output:[INNAME]=!FileNameNameOnly!%%"
    call set "output=%%output:[INROOT]=!folder_to_search!%%"
    call set "output=%%output:[OUTROOT]=!output_path!%%"
  )
  echo Command: !cmd! ^> !output!
  call %%cmd%% > !output!
  set /a C+=1
)
goto:eof

:usage
echo Run a command against a set of files filtered by type, which are searched recursively in a folder of your choice
echo easybatchprocess folder_to_search files_to_search output_path command_to_run [console_output]
echo   folder_to_search: search for files recursively trough this folder: e.g. c:\Temp
echo   files_to_search: search for file types e.g. *.* or *.mkv 
echo                 or specific names or patterns 2_English.srt or *English.srt
echo   output_path: output path for files found: e.g. C:\Temp\Output
echo   command_to_run: template command to execute for each file:
echo      tokens that are replaced: e.g. when file found is C:\Temp\Input\Season1\video1.mkv
echo              [IN] path and file name found: e.g. "C:\Temp\Input\Season1\video1.mkv"
echo              [OUT] fully qualified output file: output_path + relative path to the folder_to_search + filename: e.g. "C:\Temp\Output\Season1\video1.mkv"
echo              [INPATH] absolute path where the file is found, the full path where the file is found: e.g. C:\Temp\Input\Season1\
echo              [INPARENT] parent folder name of file that is found: e.g. Season1
echo              [OUTPATH] path where the output file created: output_path + relative path to the folder_to_search: e.g.  C:\Temp\Output\Season1\
echo              [INFILE] file name found: e.g. video1.mkv
echo              [INNAME] file name found without file extension: e.g. video1
echo              [INROOT] same as folder_to_search
echo              [OUTROOT] same as output_path
echo   console_output: optional: define console output redirection
echo                   when not defined: text goes to console (CON)
echo                   when equal to TXT: replaced by following pattern using tokens: "[OUTPATH][INFILE].txt"
echo                                                                                  which results in "C:\Temp\Output\Season1\video1.txt"
echo                 supports the tokens above mentioned at command_to_run

:end