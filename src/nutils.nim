import nutils/frontpatch
when not declared(addFloat):
  import std/formatfloat

proc nutils(frontpatch = false, lang = "no_lang", path = "") =
  echo """
  
╔═ ║ ║═╔╝╝║  ╔═╝
║ ║║ ║ ║ ║║  ══║
╝ ╝══╝ ╝ ╝══╝══╝
"""
  if frontpatch:
    addLangFrontmatter(lang, path)

when isMainModule:
  import cligen
  dispatch(nutils, short = {"frontpatch": 'f', "lang": 'l', "path": 'p'})
