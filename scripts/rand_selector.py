#!/usr/bin/python2

# Usage:
#   <set of line-delimited items> | python2 rand_selector.py [# of choices]

import random
import sys
import re

movies = sys.stdin.read().split("\n")
pattern = re.compile('(.*:.*)|(^$)', re.IGNORECASE)

if len(movies) < 1:
    print "\nUsage:\n\t<set of line-delimited items> | python2 \
rand_selector.py [# of choices]\n"
else:
    filteredMovies = filter(lambda i: not pattern.search(i), movies)
    print ""
    a = 1
    try:
        a = sys.argv[1]
    except IndexError:
        pass
    limit = min(int(a),len(filteredMovies))
    for i in range(limit):
        selection = random.choice(range(len(filteredMovies)))
        print filteredMovies.pop(selection)
