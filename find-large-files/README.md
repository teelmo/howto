# Find large Linux on Linux

[What's eating my disk space?](http://unix.stackexchange.com/questions/113840/whats-eating-my-disk-space)

# Use this to find recursively what is filling more than 10MB+ from /(root)
`sudo find / -size +10000k -print0 | xargs -0 ls -l -h`

# Repeated execution of
`sudo du -x -d1 -h /`

# You can also use du, and just dig into it manually.
`du / -h --max-depth=1 | sort -h`