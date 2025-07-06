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

    discard f_e; f_o; file_obtained 

  block expected_no_lang:
    
    # for line in f_o.lines():
    #   if line.find(lang)>=1:
    assert f_e.lines() == f_o.lines()
    # discard

  block testLang:
    # TODO
    discard
  
