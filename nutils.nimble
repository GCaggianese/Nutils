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
requires "https://github.com/disruptek/balls.git"

# Tests

task test, "Balls tests":
  exec "balls tests"
