# FFMpeg

Various ffmpeg related commands.

## Compress video

*For web*
* $ `ffmpeg -i input -vf "scale=1280:-2" -vcodec libx264 -crf 28 output`

*For other usage*
* $ `ffmpeg -i input -vf "scale=1280:-2" -vcodec libx265 -crf 28 output`

## Change aspect ratio

This helps to decrease the file size. 

* $ `ffmpeg -i input.mkv -vf "scale=iw/2:ih/2" half_the_frame_size.mkv`
* $ `ffmpeg -i input.mkv -vf "scale=iw/3:ih/3" a_third_the_frame_size.mkv`
* $ `ffmpeg -i input.mkv -vf "scale=iw/4:ih/4" a_fourth_the_frame_size.mkv`

*Bash script to do this for a folder or copy/paste*

The script includes a H.264 compressor codec and also scaling to 720px in width and corresponding height (`-2` makes the height diviable by two which is required sometimes).

```
for file in ./*.mp4
do
    fullfilename=$(basename -- "$file")
    filename="${fullfilename%.*}"
    extension="${fullfilename##*.}"

    ffmpeg -i "$file" -vf "scale=720:-2" -vcodec libx264 -crf 28 "web/${filename} Web.${extension}"
done

```

## Extract a frame as image

* $ `ffmpeg -i inputfile.mkv -vf "select=eq(n\,0)" -q:v 3 output_image.jpg`

## Remove audio

Removes the first audio stream (adjust `a:{x}` to select different audio stream).

* $ `ffmpeg -i input -map 0 -map -0:a:0 -c copy ouput`

## Split video video

Forget about subtitles

* $ `ffmpeg -i file.mp4 -t 00:50:00 -c copy smallfile1.mp4 -ss 00:50:00 -c copy smallfile2.mp4`

Include subtitles

* $ `ffmpeg -i file.mp4 -t 00:50:00  -vcodec copy -acodec copy -scodec copy smallfile1.mp4 -ss 00:50:00  -vcodec copy -acodec copy -scodec copy smallfile2.mp4`

# Speed up and slowdown

Speed up 50%

* $ `ffmpeg -i input.mp4 -filter:v "setpts=0.5*PTS" -an output.mp4`

Slow down 200%

* $ `ffmpeg -i input.mp4 -filter:v "setpts=2.0*PTS" -an output.mp4`

Speed up video and audio

* $ `ffmpeg -i input.mp4 -vf "setpts=2.0*PTS" -af "atempo=0.5" output.mp4`

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