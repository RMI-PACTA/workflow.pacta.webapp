#' Copy parameter files to directory
#'
#' Copy schema files from dependency packages to a (temporary) directory. This
#' is required, as `jsonvalidate` requires referenced schema files to exist in
#' the same directory as the referencing schema.
#'
#' @param directory Directory to copy parameter files to.
#' @return directory
#'
#' @export
prepare_schema_files <- function(directory) {
  webapp_schema_files <- list.files(
    system.file(
      "extdata", "schema",
      package = "workflow.pacta.webapp"
    ),
    full.names = TRUE
  )
  webapp_schema_copied <- file.copy(
    from = webapp_schema_files,
    to = file.path(
      directory,
      basename(webapp_schema_files)
    )
  )

  portfolio_schema_copied <- file.copy(
    from = system.file(
      "extdata", "schema", "portfolio.json",
      package = "workflow.pacta"
    ),
    to = file.path(
      directory,
      "portfolio.json"
    )
  )
  portfolio_schema_copied <- file.copy(
    from = system.file(
      "extdata", "schema", "portfolioParameters.json",
      package = "workflow.pacta"
    ),
    to = file.path(
      directory,
      "portfolioParameters.json"
    )
  )
  reporting_schema_copied <- file.copy(
    from = system.file(
      "extdata", "schema", "reportingParameters.json",
      package = "workflow.pacta.report"
    ),
    to = file.path(
      directory,
      "reportingParameters.json"
    )
  )
  stopifnot(
    webapp_schema_copied,
    portfolio_schema_copied,
    portfolio_schema_copied,
    reporting_schema_copied
  )
  return(directory)
}
