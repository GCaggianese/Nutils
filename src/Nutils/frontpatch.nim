import std/strutils

proc editFile(lang: string, file: string)=
  let f = open(file, fmReadWriteExisting)
  defer: f.close()
  var isLang = false
  var hasFrontmatter = false  
  for line in f.lines():
    if line.find(lang)>=1:
      isLang = true
    if line.find("---")>=1:
      hasFrontmatter = true
  if (isLang and hasFrontmatter):
    f.setFilePos(4)
    for line in f.lines():
      if line.find("---")>=1:
        f.setFilePos(f.getFilePos()-4)
        f.write("lang: "&lang&"\n---")
        break
    echo lang&", nice!"
  else:
    echo "Not in "&lang&":l"
