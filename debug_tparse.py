#!/usr/bin/env python3

"""
tparse.py – prettify Nim compiler test output (debug version)

Pipe raw Nim compiler output through it:
nim c -r tests/testament/test1.nim 2>&1 | ./tparse.py
"""

import re, sys
from collections import OrderedDict

# ───────────────────────── helpers ──────────────────────────

ansi = re.compile(r'\x1b\[[0-9;]*[A-Za-z]')

def strip(s: str) -> str:
    return ansi.sub('', s)

def col(txt, c):
    code = dict(red=31, green=32, yellow=33, blue=34, cyan=36)[c]
    return f"\x1b[{code}m{txt}\x1b[0m"

# ───────────────────────── regexes ─────────────────────────

R_PROJ = re.compile(r'proj: (.+?); out: .+? \[([A-Za-z]+)\]')
R_WARNING = re.compile(r'.+Warning: (.+)')
R_ERROR = re.compile(r'.+Error: (.+)')
R_TOTAL_LINES = re.compile(r'Total of lines: (\d+) ← input \| output → (\d+)')
R_LINES_EQUAL = re.compile(r'Lines Equal: (true|false)')
R_BYTE_MATCH = re.compile(r'ByteMatch: (true|false)')
R_LANG_TEST = re.compile(r'addLangFrontmatter (.+)')

def parse_nim_output():
    cases = OrderedDict()
    current_test = None
    line_count = 0
    
    for raw in sys.stdin:
        line = strip(raw.rstrip('\n'))
        line_count += 1
        
        print(f"DEBUG {line_count}: {line}", file=sys.stderr)
        
        # Skip empty lines
        if not line:
            print("DEBUG: Skipping empty line", file=sys.stderr)
            continue
            
        # Don't skip hint lines - let's process them all for now
        
        # Extract project info and status
        if (m := R_PROJ.match(line)):
            proj_path = m.group(1)
            status_code = m.group(2)
            print(f"DEBUG: Found proj line - path: {proj_path}, status: {status_code}", file=sys.stderr)
            
            # Extract test name from path
            test_name = proj_path.split('/')[-1] if '/' in proj_path else proj_path
            current_test = test_name
            
            # Determine pass/fail status
            status = "PASS" if status_code in ["SuccessX", "Success"] else "FAIL"
            
            cases[current_test] = {
                "status": status,
                "proj_path": proj_path,
                "status_code": status_code,
                "warnings": [],
                "errors": [],
                "details": [],
                "stdout": [],
                "total_lines": [],
                "lines_equal": None,
                "byte_match": None
            }
            print(f"DEBUG: Created test case for {current_test}", file=sys.stderr)
            continue
        
        if not current_test:
            print("DEBUG: No current test, skipping line", file=sys.stderr)
            continue
            
        info = cases[current_test]
        
        # Capture warnings
        if (m := R_WARNING.match(line)):
            warning = m.group(1)
            info["warnings"].append(warning)
            print(f"DEBUG: Found warning: {warning}", file=sys.stderr)
            continue
            
        # Capture errors
        if (m := R_ERROR.match(line)):
            error = m.group(1)
            info["errors"].append(error)
            info["status"] = "FAIL"
            print(f"DEBUG: Found error: {error}", file=sys.stderr)
            continue
            
        # Capture total lines comparisons
        if (m := R_TOTAL_LINES.match(line)):
            expected, got = m.group(1), m.group(2)
            info["total_lines"].append((expected, got))
            print(f"DEBUG: Found total lines: {expected} -> {got}", file=sys.stderr)
            if expected != got:
                info["status"] = "FAIL"
                info["details"].append(f"Total of lines: {expected} ← input | output → {got}")
            continue
            
        # Capture equality checks
        if (m := R_LINES_EQUAL.match(line)):
            is_equal = m.group(1) == "true"
            info["lines_equal"] = is_equal
            print(f"DEBUG: Found lines equal: {is_equal}", file=sys.stderr)
            if not is_equal:
                info["status"] = "FAIL"
                info["details"].append("Lines not equal")
            continue
            
        if (m := R_BYTE_MATCH.match(line)):
            is_match = m.group(1) == "true"
            info["byte_match"] = is_match
            print(f"DEBUG: Found byte match: {is_match}", file=sys.stderr)
            if not is_match:
                info["status"] = "FAIL"
                info["details"].append("Byte match failed")
            continue
            
        # Collect relevant test output lines
        if (line.startswith('addLangFrontmatter') or 
            line.startswith('Frontmatter:') or 
            line.startswith('Found:') or 
            line.startswith('Not in') or 
            line.startswith('Expected path:') or 
            line.startswith('Obtained path:')):
            info["stdout"].append(line)
            print(f"DEBUG: Added to stdout: {line}", file=sys.stderr)
            
    print(f"DEBUG: Final cases count: {len(cases)}", file=sys.stderr)
    for name, case in cases.items():
        print(f"DEBUG: Test {name}: {case}", file=sys.stderr)
    
    return cases

def print_results(cases):
    if not cases:
        print("No test output to parse.")
        return
        
    width = max(len(p) for p in cases) if cases else 30
    bar = '─' * (width + 48)
    
    print("\nTest Results")
    print(bar)
    
    for test_name, info in cases.items():
        tag = col("✓ PASS", "green") if info["status"] == "PASS" else col("✗ FAIL", "red")
        print(f"{test_name:<{width}} {tag}")
        
        if info["status"] == "FAIL":
            for detail in info["details"]:
                print(" " * (width + 2) + col("→ ", "yellow") + detail)
                
            for error in info["errors"]:
                print(" " * (width + 2) + col("→ ", "yellow") + f"Error: {error}")
        
        for warning in info["warnings"]:
            print(" " * (width + 2) + col("→ ", "yellow") + f"Warning: {warning}")
            
        if info["stdout"]:
            print(" " * (width + 2) + col("stdout:", "blue"))
            for ln in info["stdout"]:
                print(" " * (width + 4) + ln)
                
    print(bar)

def print_table_results(cases):
    if not cases:
        return
        
    print("\nTest Summary Table")
    print("| Test | Status | Lines Match | Byte Match | Warnings | Errors |")
    print("|------|--------|-------------|------------|----------|--------|")
    
    for test_name, info in cases.items():
        status = "✓ PASS" if info["status"] == "PASS" else "✗ FAIL"
        lines_match = "✓" if info["lines_equal"] else "✗" if info["lines_equal"] is not None else "N/A"
        byte_match = "✓" if info["byte_match"] else "✗" if info["byte_match"] is not None else "N/A"
        warnings = str(len(info["warnings"]))
        errors = str(len(info["errors"]))
        
        print(f"| {test_name} | {status} | {lines_match} | {byte_match} | {warnings} | {errors} |")

# ─────────────────────── main ───────────────────────

if __name__ == "__main__":
    cases = parse_nim_output()
    print_results(cases)
    print_table_results(cases)
