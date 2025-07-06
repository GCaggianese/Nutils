proc openFilesToTest(file: string)=
  let f_e = open("./expected_frontpatch/expected_no_lang.md", fmRead)
  defer: f_e.close()
  let file_obtained = "./obtained_frontpatch/obtained_no_lang.md"
  let f_o = open(file_obtained, fmRead)
  defer: f_o.close()

