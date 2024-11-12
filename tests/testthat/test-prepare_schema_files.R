test_that("prepare_schema_files copies files correctly.", {
  dir <- withr::local_tempdir()
  out_dir <- prepare_schema_files(dir)
  expect_identical(
    expected = dir,
    object = out_dir
  )
  expect_true(
    file.exists(file.path(dir, "portfolio.json"))
  )
  expect_identical(
    expected = readLines(file.path(dir, "portfolio.json")),
    object = readLines(system.file(
      "extdata", "schema", "portfolio.json",
      package = "workflow.pacta"
    ))
  )
  expect_true(
    file.exists(file.path(dir, "portfolioParameters.json"))
  )
  expect_identical(
    expected = readLines(file.path(dir, "portfolioParameters.json")),
    object = readLines(system.file(
      "extdata", "schema", "portfolioParameters.json",
      package = "workflow.pacta"
    ))
  )
  expect_true(
    file.exists(file.path(dir, "reportingParameters.json"))
  )
  expect_identical(
    expected = readLines(file.path(dir, "reportingParameters.json")),
    object = readLines(system.file(
      "extdata", "schema", "reportingParameters.json",
      package = "workflow.pacta.report"
    ))
  )
})
