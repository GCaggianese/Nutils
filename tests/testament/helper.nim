import std/strutils, std/os
import std/sha1 

proc openFilesToTest*(name: string): (File, File) =
  # Always resolve relative to this helper’s location in `tests` folder
  let testsDir = currentSourcePath().parentDir
  let expPath = joinPath(testsDir, "expected_frontpatch", "expected_" & name & ".md")
  let obtPath = joinPath(testsDir, "obtained_frontpatch", "obtained_" & name & ".md")
  echo "Expected path: ", expPath
  echo "Obtained path: ", obtPath
  (open(expPath, fmRead), open(obtPath, fmRead))

proc countLines*(filename: string): int =
  for _ in lines(filename): inc result

# Run only after checking file1 and file2 have the same number of lines!!
proc allLinesEqual*(filename1: string, filename2: string): bool =
  let f1 = open(filename1)
  let f2 = open(filename2)
  defer: f1.close()
  defer: f2.close()
  for line in f1.lines():
    if line != f2.readLine():
      return false
  return true

proc filesMatch*(file1, file2: string): bool =
  result = secureHashFile(file1) == secureHashFile(file2)
