#!/bin/sh

# unclobber current dir.
rm -vf *.aux *.log `grep -li "^% Creator: GNU LilyPond" *.out` *.orig *~
rm -vf `grep -li "Creator: mi2mu" *.midi.ly`
rm -vf `grep -li "Creator: GNU LilyPond" *.midi`
rm -vf `find -name 'core'`
rm -vf `find -name *.orig`
rm -vf `find -name *.rej`

# docxx mess
rm -vf *dvi
rm -vf *.class  HIER*.html dxxgifs.tex gifs.db icon?.gif logo.gif down.gif \
    aindex.html index.html
