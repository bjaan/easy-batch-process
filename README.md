# Easy Batch Process #

## Introduction ##

Run a command against a set of files filtered by type, which are searched recursively in a folder of your choice.

It determines the relative output folder path which is automatically created, and allows you to customize the command for each file.

Example: re-encode a folder of Matroska video files for all seasons of the fictional The Night Warriors show into HEVC using FFMPEG:

`easybatchprocess C:\Temp\The Night Warriors *.mkv C:\Temp\Output "C:\ffmpeg\bin\ffmpeg.exe -i [IN] -map 0 -c copy -c:v libx265 -crf 28 [OUT]"`

It will generate the following commands and execute them:

```
mkdir C:\Temp\Output\Season 1"
C:\ffmpeg\bin\ffmpeg.exe -i C:\Temp\The Night Warriors\Season 1\TNW-S01E01-Haruken.mkv" -map 0 -c copy -c:v libx265 -crf 28 C:\Temp\Output\Season 1\TNW-S01E01-Haruken.mkv
C:\ffmpeg\bin\ffmpeg.exe -i C:\Temp\The Night Warriors\Season 1\TNW-S01E02-Quantum.mkv" -map 0 -c copy -c:v libx265 -crf 28 C:\Temp\Output\Season 1\TNW-S01E02-Quantum.mkv
...
mkdir C:\Temp\Output\Season 2"
C:\ffmpeg\bin\ffmpeg.exe -i C:\Temp\The Night Warriors\Season 2\TNW-S02E01-Lasers.mkv" -map 0 -c copy -c:v libx265 -crf 28 C:\Temp\Output\Season 2\TNW-S02E01-Lasers.mkv
C:\ffmpeg\bin\ffmpeg.exe -i C:\Temp\The Night Warriors\Season 2\TNW-S02E02-Pendulum.mkv" -map 0 -c copy -c:v libx265 -crf 28 C:\Temp\Output\Season 2\TNW-S01E02-Pendulum.mkv
...
etc.
```

This more elaborate example will copy all of the currently logged user's picture files to a USB-drive located on the E:\ drive:

`easybatchprocess %USERPROFILE% "*.jpg;*.png;*.bmp;*.jpeg" E:\ "copy [IN] [OUTPATH]"`

This other example will copy the source files that are missing in the folder of processed files, with the same names, to another folder to allow processing of missing files separately (when Video2X failed for a fraction of the frames to process the failed ones afterwards - `cmd.exe /c` was still needed due to a limitation in the batch file processor which cannot handle IF / FOR / REM in a CALL command):

`easybatchprocess "C:\Temp\original" *.png "C:\Temp\missing" "cmd.exe /c if not exist ""C:\Temp\processed\[INFILE]"" copy [IN] [OUT]"`

This is example is handy to copy a number of files sitting a sub-folder, like subtitle files where the parent folder is matching the video file name:

`easybatchprocess.bat C:\Temp\Subs 2_English.srt C:\Temp\Subs2 "copy [IN] ""[OUTROOT]\[INPARENT].en.srt"""`

This is a useful one when you want to run DUMPBIN.EXE /EXPORTS against a folder of .lib-files and create a folder with .txt files with the output of each command, to search through

`easybatchprocess.bat C:\Temp\lib *.lib "C:\Temp\libexports" "dumpbin /EXPORTS [IN]" TXT` (you run this from the Visual Studio tools command prompt)

## Full usage ##

```
easybatchprocess folder_to_search files_to_search output_path command_to_run [console_output]
  folder_to_search: search for files recursively trough this folder: e.g. c:\Temp
  files_to_search: search for file types e.g. *.* or *.mkv
                or specific names or patterns 2_English.srt or *English.srt
  output_path: output path for files found: e.g. C:\Temp\Output
  command_to_run: template command to execute for each file:
     tokens that are replaced: e.g. when file found is C:\Temp\Input\Season1\video1.mkv
             [IN] path and file name found: e.g. "C:\Temp\Input\Season1\video1.mkv"
             [OUT] fully qualified output file: output_path + relative path to the folder_to_search + filename: e.g. "C:\Temp\Output\Season1\video1.mkv"
             [INPATH] absolute path where the file is found, the full path where the file is found: e.g. C:\Temp\Input\Season1\
             [INPARENT] parent folder name of file that is found: e.g. Season1
             [OUTPATH] path where the output file created: output_path + relative path to the folder_to_search: e.g.  C:\Temp\Output\Season1\
             [INFILE] file name found: e.g. video1.mkv
             [INNAME] file name found without file extension: e.g. video1
             [INROOT] same as folder_to_search
             [OUTROOT] same as output_path
  console_output: optional: define console output redirection
                  when not defined: text goes to console (CON)
                  when equal to TXT: replaced by following pattern using tokens: "[OUTPATH][INFILE].txt"
                                                                                 which results in "C:\Temp\Output\Season1\video1.txt"
                supports the tokens above mentioned at command_to_run
```

