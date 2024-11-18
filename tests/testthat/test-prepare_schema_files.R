test_that("prepare_schema_files copies files correctly.", {
  dir <- withr::local_tempdir()
  out_dir <- prepare_schema_files(dir)
  expect_identical(
    expected = dir,
    object = out_dir
  )

  webapp_schema_files <- list.files(
    system.file(
      "extdata", "schema",
      package = "workflow.pacta.webapp"
    ),
    full.names = TRUE
  )
  for (xx in webapp_schema_files) {
    expect_true(file.exists(file.path(dir, basename(xx))))
    expect_identical(
      expected = readLines(xx),
      object = readLines(file.path(dir, basename(xx)))
    )
  }

  expect_true(
    file.exists(file.path(dir, "portfolio.json"))
  )
  expect_identical(
    object = readLines(file.path(dir, "portfolio.json")),
    expected = readLines(system.file(
      "extdata", "schema", "portfolio.json",
      package = "workflow.pacta"
    ))
  )
  expect_true(
    file.exists(file.path(dir, "portfolioParameters.json"))
  )
  expect_identical(
    object = readLines(file.path(dir, "portfolioParameters.json")),
    expected = readLines(system.file(
      "extdata", "schema", "portfolioParameters.json",
      package = "workflow.pacta"
    ))
  )
  expect_true(
    file.exists(file.path(dir, "reportingParameters.json"))
  )
  expect_identical(
    object = readLines(file.path(dir, "reportingParameters.json")),
    expected = readLines(system.file(
      "extdata", "schema", "reportingParameters.json",
      package = "workflow.pacta.report"
    ))
  )
})
