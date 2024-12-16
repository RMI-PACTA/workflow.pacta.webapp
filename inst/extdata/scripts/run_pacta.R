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
  schema_file = file.path(schema_tempdir, "PACTAParameters.json"),
  raw_schema_file = file.path(schema_tempdir, "rawParameters.json"),
  force_array = c("portfolio", "files")
)

workflow.pacta.webapp::run_webapp_workflow(
  params = params,
  raw_params = raw_params,
  run_analysis = TRUE,
  run_reporting = TRUE
)
