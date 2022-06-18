# Easy Batch Process #

## Introduction ##

Run a command against a set of files filter by type, which are searched recursively in a folder of your choice.

It calculates the relative output folder path and the output file folder is automatically created.

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

This is example is handy to copy a number of files sitting a subfolder, like subtitle files where the parent folder is match the video file:

`easybatchprocess.bat C:\Temp\Subs 2_English.srt C:\Temp\Subs2 "copy [IN] ""[OUTROOT]\[INPARENT].en.srt"""`

## Full usage ##

```
easybatchprocess.bat folder_to_search files_to_search output_path command_to_run
  folder_to_search: search for files recursively trough this folder: e.g. c:\Temp\Input
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
             [INROOT] same as folder_to_search
             [OUTROOT] same as output_path
```

