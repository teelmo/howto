#!/bin/bash

# Get latest snapshot.
wget http://libav.org/releases/libav-snapshot.tar.bz2 -O ~/Downloads/libav-snapshot.tar.bz2

# Make target directory.
mkdir ~/Downloads/libav-snapshot

# Untar file.
tar -xvzf ~/Downloads/libav-snapshot.tar.bz2 -C ~/Downloads/libav-snapshot --strip-components=1

# Remove tar.
rm ~/Downloads/libav-snapshot.tar.bz2

# Change directory.
cd ~/Downloads/libav-snapshot

# Configure.
./configure \
--extra-cflags=-I/opt/local/include --extra-ldflags=-L/opt/local/lib \
--enable-gpl --enable-libx264 --enable-libxvid \
--enable-version3 --enable-libopencore-amrnb --enable-libopencore-amrwb \
--enable-nonfree --enable-libfaac \
--enable-libmp3lame --enable-libspeex --enable-libvorbis --enable-libtheora --enable-libvpx \
--enable-libopenjpeg --enable-libfreetype --enable-doc --enable-gnutls --enable-shared

# Build.
make && sudo make install

# Remove dir.
rm -rf ~/Downloads/libav-snapshot
