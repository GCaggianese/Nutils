import nutils/frontpatch
import os
import std/parseopt

var varName: string = "defaultValue"
var isFrontpatch = false

for kind, key, val in getopt():
  case kind
  of cmdArgument:
    discard
  of cmdShortOption:
    case key:
    of "f":
      varName = val
      isFrontpatch = true
  of cmdLongOption :
    case key:
    of "frontpatch": 
      varName = val 
      isFrontpatch = true
  of cmdEnd:
    discard

if isFrontpatch:
  case varName
  of "defaultValue":
    echo "Please enter a valid frontpatch option."
  of "lang":
    echo "Please specify the directory to patch:..."
    # User input to apply frontpatch
  else:
    echo "Please enter a valid frontpatch option."
else:
  echo "Please enter a valid option."
  
