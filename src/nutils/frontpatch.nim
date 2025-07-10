import std/strutils

# TODO: add counter of "---",
# after the 2nd one finding lang doens't count
# shouldn't include it neither.
proc addLangFrontmatter*(lang: string, file: string)=
  let f = open(file, fmReadWriteExisting)
  var isLang = false
  var alreadyLang = false
  var frontmatter = 0  
  for line in f.lines():
    if contains(line,"lang: "&lang):
      alreadyLang = true
      return
    if contains(line,"---"):
      inc frontmatter
      echo "Frontmatter: " & $(frontmatter >= 1)
    if contains(line, lang) and (0 < frontmatter and frontmatter < 3):
      isLang = true
      echo "Found: "&lang
  if (isLang and frontmatter >= 1 ):
    f.setFilePos(4)
    for line in f.lines():
      echo line
      if contains(line,"---"):
        f.setFilePos(f.getFilePos()-4)
        var savePos = f.getFilePos()
        var lineAux = f.readLine()
        for line2 in f.lines():
          lineAux = lineAux&'\n'&line2
        f.setFilePos(savePos)
        f.writeLine("lang: "&lang)
        f.writeLine(lineAux)
        break
    echo lang&", nice!"
  else:
    echo "Not in "&lang
  defer: f.close()
