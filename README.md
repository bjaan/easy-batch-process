# Easy Batch Process #

## Introduction ##

Run a command against a set of files by type, which are searched recursively in a folder of your choice.

It calculates the relative output folder path and the output file folder is automatically created.

example: re-encode a folder of Matroska video files for all seasons of the fictional The Night Warriors show into HEVC using FFMPEG:

`easybatchprocess.bat C:\Temp\The Night Warriors *.mkv C:\Temp\Output "C:\ffmpeg\bin\ffmpeg.exe -i [IN] -map 0 -c copy -c:v libx265 -crf 28 [OUT]"`

It will generate the following command and execute them:

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

## Full usage ##

```
easybatchprocess.bat folder_to_search file_types output_path command_to_run
  folder_to_search: search for files recursively trough this folder: e.g. c:\Temp\Input
  file_types: search for filetypes e.g. *.* or *.mkv
  output_path: output path for files found: e.g. C:\Temp\Output
  command_to_run: template command to execute for each file:
     tokens that are replaced: e.g. when file found is C:\Temp\Input\Season1\video1.mkv
             [IN] path and file name found: e.g. "C:\Temp\Input\Season1\video1.mkv"
             [OUT] fully qualifed output file: output_path + relative path to the folder_to_search + filename: e.g. "C:\Temp\Output\Season1\video1.mkv"
             [INPATH] absolute path where the file is found, the full path where the file is found: e.g. C:\Temp\Input\Season1\
             [OUTPATH] path where the output file created: output_path + relative path to the folder_to_search: e.g.  C:\Temp\Output\Season1\
```

