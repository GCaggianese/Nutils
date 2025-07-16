import std/strutils

proc addLangFrontmatter*(lang: string, file: string) =
  let f = open(file, fmReadWriteExisting)
  var isLang = false
  var alreadyLang = false
  var frontmatter = 0
  for line in f.lines():
    if contains(line, "lang: " & lang):
      alreadyLang = true
      echo "No changes made: 'lang: " & lang & "' already there."
      return
    if contains(line, "---"):
      inc frontmatter
    if contains(line, lang) and (0 < frontmatter and frontmatter < 3):
      isLang = true
  if (isLang and frontmatter >= 1):
    f.setFilePos(4)
    for line in f.lines():
      if contains(line, "---"):
        f.setFilePos(f.getFilePos() - 4)
        var savePos = f.getFilePos()
        var lineAux = f.readLine()
        for line2 in f.lines():
          lineAux = lineAux & '\n' & line2
        f.setFilePos(savePos)
        f.writeLine("lang: " & lang)
        f.writeLine(lineAux)
        break
    echo "Tag '" & lang & "' found, patching..."
    echo "Frontmatter patched!"
  else:
    echo "No changes made: tag '" & lang & "' not found."
  defer:
    f.close()
