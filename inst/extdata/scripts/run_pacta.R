logger::log_threshold(Sys.getenv("LOG_LEVEL", "INFO"))

raw_params <- commandArgs(trailingOnly = TRUE)
params <- pacta.workflow.utils::parse_raw_params(
  json = raw_params,
  inheritence_search_paths = system.file(
    "extdata", "parameters",
    package = "workflow.pacta"
  ),
  schema_file = system.file(
    "extdata", "schema", "portfolioParameters.json",
    package = "workflow.pacta"
  ),
  raw_schema_file = system.file(
    "extdata", "schema", "rawParameters.json",
    package = "workflow.pacta"
  )
)

manifest_info <- workflow.pacta::run_pacta(params)

workflow.pacta.report:::run_pacta_reporting_process(
  commandArgs(trailingOnly = TRUE)
)
