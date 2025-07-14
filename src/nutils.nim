import nutils/frontpatch
import os
when not declared(addFloat): import std/formatfloat

proc nutils(frontpatch = false, lang = "no_lang", path = "") =
  echo "frontpatch:", $frontpatch, " lang:", lang, " path:", path

when isMainModule:
  import cligen
  dispatch(nutils, short={"frontpatch": 'f', "lang": 'l', "path": 'p'})

