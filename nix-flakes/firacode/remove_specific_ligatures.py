#!/usr/bin/env python

import sys

def find_calt(fp):
    fp.seek(0)
    prev_pos = fp.tell()
    line = fp.readline()
    line_num = 0
    while line.strip("\n") != "name = calt;" and line != "":
        prev_pos = fp.tell() - len(line)
        line = fp.readline()
        line_num += 1

    fp.seek(prev_pos, 0)
    calt_line = fp.readline()

    # Previous line number since that's the calt code line.
    return line_num - 1, prev_pos, calt_line

if __name__ == "__main__":
    args = sys.argv[1:]
    with open("FiraCode.glyphs", "r") as f:
        lines = f.readlines()
        line_num, pos, calt_line = find_calt(f)

    for lig in args:
        print(f" Scanning for {lig}...")
        start = None
        try:
            starting = f"lookup {lig}" + r" {\012"
            start = calt_line.index(starting) + len(starting)
        except ValueError as e:
            print(f"Error: could not find start: {e}")
            exit(1)

        end = None
        try:
            ending = r"\012} " + lig + r";\012\012"
            end = calt_line.index(ending)
        except ValueError as e:
            try:
                ending = r"\012} " + lig + r';";'
                end = calt_line.index(ending)
            except ValueError as e:
                print(f"Error: could not find end: {e}")
                exit(1)

        print(f"  Removing {lig}")
        calt_line = calt_line[:start] + calt_line[end:]

    print("\n Writing new glyphs file")
    with open("FiraCode.glyphs", "w") as nf:
        lines[line_num] = calt_line
        nf.writelines(lines)
