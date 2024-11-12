logger::log_threshold(Sys.getenv("LOG_LEVEL", "INFO"))

schema_tempdir <- tempdir()
workflow.pacta.webapp::prepare_schema_files(
  directory = schema_tempdir
)

raw_params <- commandArgs(trailingOnly = TRUE)
params <- pacta.workflow.utils::parse_raw_params(
  json = raw_params,
  inheritence_search_paths = c(
    system.file(
      "extdata", "parameters",
      package = "workflow.pacta.webapp"
    ),
    system.file(
      "extdata", "parameters",
      package = "workflow.pacta"
    ),
    system.file(
      "extdata", "parameters",
      package = "workflow.pacta.report"
    )
  ),
  schema_file = system.file(
    "extdata", "schema", "PACTAParameters.json",
    package = "workflow.pacta.webapp"
  ),
  raw_schema_file = system.file(
    "extdata", "schema", "rawParameters.json",
    package = "workflow.pacta.webapp"
  )
)

workflow.pacta.webapp::run_webapp_workflow(
  params = params,
  raw_params = raw_params,
  run_analysis = TRUE,
  run_reporting = TRUE
)
