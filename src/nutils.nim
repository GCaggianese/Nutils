import nutils/frontpatch
import os

var cmdIn = commandLineParams()
if cmdIn.len() <= 1:
  for arg in cmdIn:
    echo arg

else:
  echo "Too many arguments."
