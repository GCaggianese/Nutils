import nutils/frontpatch
import helper
import balls

suite "test balls":

  setup:
    discard "nice!"

  block testTester:
    assert 2 == 2


suite "addLangFrontmatter":

  setup:
    # TODO: change this to helper funct.
    var fileOutput = "tests/obtained_frontpatch/expected_no_lang.md"
    var fileTest = "no_lang"
    frontpatch.addLangFrontmatter(fileTest, fileOutput)
    var (f_e, f_o) = helper.openFilesToTest(fileTest)

    defer: f_e.close()
    defer: f_o.close()
    discard (f_e, f_o)
    
  block expected_no_lang:

    # for line in f_o.lines():
    #   if line.find(lang)>=1:
    # assert f_e.lines() == f_o.lines()
    discard

  block testLang:
    # TODO
    setup:
      var a = true
      discard a
    discard
