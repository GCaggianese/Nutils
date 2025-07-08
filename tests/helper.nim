import std/strutils
import std/os

proc openFilesToTest*(name: string): (File, File) =
  # Always resolve relative to this helper’s location in `tests` folder
  let testsDir = currentSourcePath().parentDir
  let expPath = joinPath(testsDir, "expected_frontpatch", "expected_" & name & ".md")
  let obtPath = joinPath(testsDir, "obtained_frontpatch", "expected_" & name & ".md")
  (open(expPath, fmRead), open(obtPath, fmRead))

proc countLines*(filename: string): int =
  for _ in lines(filename): inc result
