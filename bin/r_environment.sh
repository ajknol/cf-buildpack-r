#!/bin/bash

export PATH="/app/vendor/R/bin:/app/.apt/usr/bin:/app/bin:/usr/ruby1.9.2/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/app/tesseract-ocr/tessdata:$PATH"
export R_INCLUDE="/app/vendor/R/lib64/R/include"
export LD_LIBRARY_PATH="/app/.apt/usr/lib/libblas:/app/.apt/usr/lib/lapack:/app/.apt/usr/lib/x86_64-linux-gnu:/app/.apt/usr/lib/i386-linux-gnu:/app/.apt/usr/lib:$LD_LIBRARY_PATH"
export LIBRARY_PATH="/app/.apt/usr/lib/x86_64-linux-gnu:/app/.apt/usr/lib/i386-linux-gnu:/app/.apt/usr/lib:$LIBRARY_PATH"
export INCLUDE_PATH="/app/.apt/usr/include:$INCLUDE_PATH"
export CPATH="$INCLUDE_PATH"
export CPPPATH="$INCLUDE_PATH"
export PKG_CONFIG_PATH="/app/.apt/usr/lib/x86_64-linux-gnu/pkgconfig:/app/.apt/usr/lib/i386-linux-gnu/pkgconfig:/app/.apt/usr/lib/pkgconfig:$PKG_CONFIG_PATH"
export LDFLAGS="-L/app/.apt/usr/lib/libblas -L/app/.apt/usr/lib/lapack $LDFLAGS"
export TESSDATA_PREFIX="/app/tesseract-ocr/tessdata"
