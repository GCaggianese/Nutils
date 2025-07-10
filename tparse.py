#!/usr/bin/env python3
"""
tparse.py  –  prettify Nim Testament output  (v4)

Pipe raw Testament output through it:
    testament r tests/testament/test1.nim 2>&1 | ./tparse.py
"""

import re, sys
from collections import OrderedDict

# ───────────────────────── helpers ──────────────────────────
ansi = re.compile(r'\x1b\[[0-9;]*[A-Za-z]')
def strip(s: str) -> str: return ansi.sub('', s)

def col(txt, c):
    code = dict(red=31, green=32, yellow=33, blue=34, cyan=36)[c]
    return f"\x1b[{code}m{txt}\x1b[0m"

# ───────────────────────── regexes  ─────────────────────────
R_FAIL = re.compile(r'^\s*FAIL:\s+(\S+)')
R_PASS = re.compile(r'^\s*PASS:\s+(\S+)')
R_LABEL= re.compile(r'^\s*(Expected|Gotten):\s*$')
R_EXIT = re.compile(r'^\s*exitcode:\s*(\d+)')
R_OUT  = re.compile(r'^\s*Output:\s*$')
R_ERR  = re.compile(r'AssertionDefect|unhandled exception')
R_TOTAL= re.compile(r'^(FAILURE!|SUCCESS!)')

cases = OrderedDict()
current  = None
capture  = None        # None | 'expect' | 'got' | 'stdout'
blank_in_stdout = 0

for raw in sys.stdin:
    line = strip(raw.rstrip('\n'))

    # new test section
    if (m := R_FAIL.match(line)):
        current = m.group(1)
        cases[current] = {"status":"FAIL","exp":None,"got":None,
                          "details":[],"stdout":[]}
        capture = None
        continue
    elif (m := R_PASS.match(line)):
        current = m.group(1)
        cases[current] = {"status":"PASS","details":[]}
        capture = None
        continue

    if current is None:
        continue

    info = cases[current]

    # label blocks
    if R_LABEL.match(line):
        capture = 'expect' if line.strip().startswith('Expected') else 'got'
        continue
    if capture in ('expect','got') and (m := R_EXIT.match(line)):
        info[capture] = m.group(1)
        capture = None
        continue

    # stdout block
    if R_OUT.match(line):
        capture = 'stdout'
        continue
    if capture == 'stdout':
        if R_TOTAL.match(line):          # reached global summary
            capture = None
        elif line.startswith('diff --git'):
            capture = None
        elif line.strip() == '':
            blank_in_stdout += 1
            if blank_in_stdout > 1:      # consecutive blanks = end
                capture = None
            # ignore pure blank line
        else:
            blank_in_stdout = 0
            # if len(info["stdout"]) < 40 and not line.startswith('---'):
            info["stdout"].append(line)
        continue

    # other diagnostics
    if info["status"] == "FAIL":
        if "Total of lines" in line:
            info["details"].append(line)
        elif R_ERR.search(line):
            info["details"].append(line)

    if R_TOTAL.match(line):
        break

# ─────────────────────── pretty print ───────────────────────
if not cases:
    print("No test output to parse.")
    sys.exit(0)

width = max(len(p) for p in cases)
bar   = '─' * (width + 48)
print("\nTest Results")
print(bar)

for path, info in cases.items():
    tag = col("✓ PASS","green") if info["status"]=="PASS" else col("✗ FAIL","red")
    print(f"{path:<{width}}  {tag}")

    if info["status"]=="FAIL":
        if info.get("exp") and info.get("got"):
            print(" "*(width+2)+col("→ ","yellow")+
                  f"exitcode: expected {info['exp']} got {info['got']}")
        for d in info["details"]:
            print(" "*(width+2)+col("→ ","yellow")+d)
        if out:=info.get("stdout"):
            print(" "*(width+2)+col("stdout:","blue"))
            for ln in out:
                print(" "*(width+4)+ln)
            if len(out)==40:
                print(" "*(width+4)+"(truncated)")

print(bar)

