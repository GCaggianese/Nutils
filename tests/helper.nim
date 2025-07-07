import std/strutils
import std/os

# proc openFilesToTest*(file: string): (File, File) =
#   let f_e = open("./expected_frontpatch/expected_"&file&".md", fmRead)
#   let file_obtained = "./obtained_frontpatch/obtained_"&file&".md"
#   let f_o = open(file_obtained, fmRead)
#   return (f_e, f_o)

proc openFilesToTest*(name: string): (File, File) =
  # Always resolve relative to this helper’s location in `tests` folder
  let testsDir = currentSourcePath().parentDir
  let expPath = joinPath(testsDir, "expected_frontpatch", "expected_" & name & ".md")
  let obtPath = joinPath(testsDir, "obtained_frontpatch", "expected_" & name & ".md")
  (open(expPath, fmRead), open(obtPath, fmRead))
