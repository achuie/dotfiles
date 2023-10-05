#!/usr/bin/env python

import sys

if __name__ == "__main__":
    args = sys.argv[1:]
    calt_line = None
    with open("FiraCode.glyphs") as f:
        prev_pos = f.tell()
        line = f.readline()
        while line != "name = calt;":
            prev_pos = f.tell()
            line = f.readline()

        f.seek(prev_pos)
        calt_line = f.readline()

    for lig in args:
        start = calt_line.index(f"lookup {lig}")
        end = calt_line.index(lig + r";\012\012")

        calt_line = calt_line[:start] + calt_line[end+len(end):]
