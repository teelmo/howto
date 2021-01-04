# Move large amount of files

[using -exec command on mac os x](http://apple.stackexchange.com/questions/52197/using-exec-command-on-mac-os-x)
[Argument list too long when copying/deleting/moving files on Linux](https://www.electrictoolbox.com/argument-list-too-long-linux/)

# Move large amount of files from source to target.
* $ `find {source} -iname "*.{filetype}" -exec mv {} {target} \;`

# Example move all pdf files from current folder to /home/teelmo
* $ `find . -iname "*.pdf" -exec mv {} /home/teelmo \;`
