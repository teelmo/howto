# FFMpeg

Various ffmpeg related commands.

## Change aspect ratio

This helps to decrease the file size. 

* $ `ffmpeg -i input.mkv -vf "scale=iw/2:ih/2" half_the_frame_size.mkv`
* $ `ffmpeg -i input.mkv -vf "scale=iw/3:ih/3" a_third_the_frame_size.mkv`
* $ `ffmpeg -i input.mkv -vf "scale=iw/4:ih/4" a_fourth_the_frame_size.mkv`

## Split video video

Forget about subtitles

* $ `ffmpeg -i file.mp4 -t 00:50:00 -c copy smallfile1.mp4 -ss 00:50:00 -c copy smallfile2.mp4`

Include subtitles

* $ `ffmpeg -i file.mp4 -t 00:50:00  -vcodec copy -acodec copy -scodec copy smallfile1.mp4 -ss 00:50:00  -vcodec copy -acodec copy -scodec copy smallfile2.mp4`

## Join subtitles and video file

This one burns the subtitles

* $ `ffmpeg -i "file.mp4" -vf subtitles="file.srt" "output.mp4"`

This one attaches the subtitle track

* $ `ffmpeg -i file.mp4 -i file.srt -c copy -c:s mov_text output.mp4`

## Join multiple .mp4 files

* File names cannot contain special characters. 
* This might work for other file formats also. 
* Make sure you are running the commands in the right folder.

1. Make a file containing the files to be joined.

* $ `echo file file1.mp4 > list.txt`
* $ `echo file file2.mp4 >> list.txt` 

2. Join the files.

* $ `ffmpeg -f concat -i list.txt -c copy output.mp4`

or this also takes into account subtitles.

* $ `ffmpeg -f concat -safe 0 -i list.txt -vcodec copy -acodec copy -scodec copy output2.mkv -y`

See https://forums.techguy.org/threads/batch-file-to-merge-video-and-subtitle-files.1185352/ and https://trac.ffmpeg.org/wiki/Concatenate