import nutils/frontpatch
import std/strutils
import helper
import balls

suite "test balls":

  setup:
    discard "nice!"

  block testTester:
    assert 2 == 2

suite "addLangFrontmatter":

  var num_i: int
  var num_o: int
  var totalOfLines = "Total of lines: "
  setup:
    # TODO: change this to helper funct.
    var fileOutput = "tests/obtained_frontpatch/expected_no_lang.md"
    var fileExpected = "tests/expected_frontpatch/expected_no_lang.md"
    var fileTest = "no_lang"
    frontpatch.addLangFrontmatter(fileTest, fileOutput)
    var (f_e, f_o) = helper.openFilesToTest(fileTest)
    num_i = helper.countLines(fileExpected)
    num_o = helper.countLines(fileOutput)
    totalOfLines = totalOfLines & $num_i & " ← input | output → " & $num_o    
    defer: f_e.close()
    defer: f_o.close()  
  block expected_no_lang:

    block sameTotalOfLines:
      assert num_i == num_o
      report totalOfLines
      fail totalOfLines
        

  discard (num_i, num_o)


  block testLang:
    # TODO
    setup:
      var a = true
      discard a
    discard
