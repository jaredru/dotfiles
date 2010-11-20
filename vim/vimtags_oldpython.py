#!/usr/bin/env python

#
# Generate a source file index for use with the FileList vim plugin
#

import os
import re

# enumerate the paths we want to search
path_list = [
    os.path.join("path", "to", "files"),
    os.path.join("another", "path"),
]
paths = [path for path in path_list if os.path.exists(path)]

# we filter by full filenames and extensions
files = ["files", "without", "extensions"]
exts  = ["cpp", "h", "py", "xml"]

filter_files = "|".join([re.escape(os.sep) + f for f in files])
filter_exts  = "|".join(exts)
filter       = ".*(" + filter_files + "|(" + "\.(" + filter_exts + ")))$"

# things we don't care about
# disallow = r".*\\objd?\\.*"

# build our filters as compiled regular expressions
allowed = re.compile(filter)
# denied  = re.compile(disallow)

matches = []
def FindFiles(folder):
    # loop through this folder
    for listing in os.listdir(folder):
        # join the folder to get the full path
        fullpath = os.path.join(folder, listing)

        # if it's a directory, recurse
        if os.path.isdir(fullpath):
            FindFiles(fullpath)

        # if it matches our filters, track it
        elif allowed.match(fullpath): # and not denied.match(fullpath):
            matches.append("%s (%s)" % (listing, folder))

print "finding matches:"
print "  " + filter
# print("and not:")
# print("  " + disallow)
print

for path in paths:
    FindFiles(os.path.abspath(path))

# sort the results
print "sorting %d results" % len(matches)
matches.sort(lambda a, b: cmp(a.lower(), b.lower()))

# spit them to a file
filetags = "filetags"
print "saving to %s" % filetags

f = open(filetags, "w")
for match in matches:
    f.write(match + os.linesep)
f.close()

