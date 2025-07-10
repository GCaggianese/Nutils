import std/syncio
import ../../src/nutils/frontpatch
import helper

setStdIoUnbuffered()

echo "addLangFrontmatter no_lang"
  # test "equal number of lines, content, and bytes":
block setup:
  let fileTest = "no_lang"
  let fileOutput = "tests/testament/obtained_frontpatch/obtained_no_lang.md"
  let fileExpected = "tests/testament/expected_frontpatch/expected_no_lang.md"

  frontpatch.addLangFrontmatter(fileTest, fileOutput)


  let (f_e, f_o) = helper.openFilesToTest(fileTest)
  defer: f_e.close()
  defer: f_o.close()

  block Total_Lines: 
    let num_i = helper.countLines(fileExpected)
    let num_o = helper.countLines(fileOutput)
    let totalOfLines = "Total of lines: " & $num_i & " ← input | output → " & $num_o
    echo totalOfLines
    doAssert num_i == num_o

    block Equal_Lines:
      let equalLines = helper.allLinesEqual(fileOutput, fileExpected)
      echo "Lines Equal: ", $equalLines
      doAssert equalLines == true

    block Byte_to_Byte:
      let byteToByte = helper.filesMatch(fileOutput, fileExpected)
      echo "ByteMatch: ", $byteToByte
      doAssert byteToByte == true

echo "addLangFrontmatter es"
  # test "equal number of lines, content, and bytes":
block setup:
  let fileTest = "es"
  let fileOutput = "tests/testament/obtained_frontpatch/obtained_" & fileTest & ".md"
  let fileExpected = "tests/testament/expected_frontpatch/expected_" & fileTest & ".md"
    
  frontpatch.addLangFrontmatter(fileTest, fileOutput)

  let (f_e, f_o) = helper.openFilesToTest(fileTest)
  defer: f_e.close()
  defer: f_o.close()
    
  block Total_Lines:    
    var num_i = 0
    var num_o = 0
    num_i = helper.countLines(fileExpected)
    num_o = helper.countLines(fileOutput)
    let totalOfLines = "Total of lines: " & $num_i & " ← input | output → " & $num_o
    echo totalOfLines
    doAssert num_i == num_o

  block Equal_Lines:
    let equalLines = helper.allLinesEqual(fileOutput, fileExpected)
    echo "Lines Equal: ", $equalLines
    doAssert equalLines == true

  block Byte_to_Byte:
      let byteToByte = helper.filesMatch(fileOutput, fileExpected)
      echo "ByteMatch: ", $byteToByte
      doAssert byteToByte == true
