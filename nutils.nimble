# Package

version       = "0.1.0"
author        = "Germán Caggianese"
description   = "Nutils is a lightweight collection of Nim utilities designed to automate and standardize my web publishing"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["nutils"]

# Dependencies

requires "nim >= 2.2.4"
requires "checksums"

# Tests

task test, "Testament tests":
  exec "cp ./tests/testament/expected_frontpatch/input_es_lang.md ./tests/testament/obtained_frontpatch/obtained_es.md"
  exec "cp ./tests/testament/expected_frontpatch/expected_no_lang.md ./tests/testament/obtained_frontpatch/obtained_no_lang.md"
  exec "testament r tests/testament/test1.nim 2>&1 | ./tparse.py"

