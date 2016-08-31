#!/bin/python

# Must be run in the top-level music directory, if MPD isn't configured to use
# absolute paths.
#
# Run with:
#   $ python playlist2folder.py <MPD playlist file> <existing target directory>

import sys
import shutil
import ntpath

def pathLeaf(path):
    head,tail = ntpath.split(path)
    return tail or ntpath.basename(head)

playlist = open(sys.argv[1])
songs = playlist.readlines()
filler = 1

if len(songs) > 9:
    filler = 2
elif len(songs) > 99:
    filler = 3
elif len(songs) > 999:
    filler = 4

for songnum in range(len(songs)):
    source = songs[songnum].replace("\n","")
    dest = sys.argv[2]+"/"+str(songnum).zfill(filler)+"_"+pathLeaf(source)
    print ("  Copying "+source+" to "+dest)
    shutil.copyfile(source,dest)

print("\nDone.")
