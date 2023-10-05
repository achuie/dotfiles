#!/usr/bin/env python

import sys

def find_calt(fp):
    prev_pos = fp.tell()
    line = fp.readline()
    count = 0
    while line.strip("\n") != "name = calt;":
        prev_pos = fp.tell()
        line = fp.readline()
        count += 1

    fp.seek(prev_pos)
    calt_line = fp.readline()
    fp.seek(0)

    return count, prev_pos, calt_line, fp.readlines()

if __name__ == "__main__":
    args = sys.argv[1:]
    with open("FiraCode.glyphs", "r") as f:
        count, pos, calt_line, lines = find_calt(f)

    for lig in args:
        print(f" Scanning for {lig}...")
        try:
            start = calt_line.index(f"lookup {lig}")
            ending = lig + r";\012\012"
            end = calt_line.index(ending) + len(ending)

            print(f"  Removing {lig}")
            calt_line = calt_line[:start] + calt_line[end:]
        except ValueError as e:
            print(e)

    print("\n Writing new glyphs file")
    with open("FiraCode.glyphs", "w") as nf:
        lines[count] = calt_line
        nf.seek(0)
        for line in lines:
            nf.write(line)
