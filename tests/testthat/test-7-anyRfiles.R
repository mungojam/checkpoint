# tests for checking if R files exist in project
if(interactive()) library(testthat)

context("any R files")
test_that("it detects R files in project", {

  describe("finds R files in folder", {
    td <- make_fake_archive()
    
    it("finds R files in checkpoint", {
      expect_false(
        anyRfiles(td)
      )
      writeLines("# Hello World", con = file.path(td, "hw.R"))
      expect_true(
        anyRfiles(td)
      )
    })

    unlink(file.path(td, "hw.R"))
    
    it("finds no R files in fake checkpoint archive", {
      expect_false(
        anyRfiles(td)
      )
    })
    
    it("deals correctly with invalid project paths", {
      with_mock(
        `base::normalizePath` = function(x, winslash, mustWork)"~/",
        `base::readline` = function(x)"y",
        expect_null(validateProjectFolder(td))
      )
      
      with_mock(
        `base::normalizePath` = function(x, winslash, mustWork)"~/",
        `base::readline` = function(...)"n",
        expect_error(validateProjectFolder(td), "Scanning stopped.")
      )
    })
    
  })
})
