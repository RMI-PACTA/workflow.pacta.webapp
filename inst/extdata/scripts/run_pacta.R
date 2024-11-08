logger::log_threshold(Sys.getenv("LOG_LEVEL", "INFO"))

# Copy Schema files
invisible(
  file.copy(
    from = system.file(
      "extdata", "schema", "portfolio.json",
      package = "workflow.pacta"
      ),
    to = file.path(
      system.file(
        "extdata", "schema",
        package = "workflow.pacta.webapp"
        ),
      "portfolio.json"
    )
  )
)
invisible(
  file.copy(
    from = system.file(
      "extdata", "schema", "portfolioParameters.json",
      package = "workflow.pacta"
      ),
    to = file.path(
      system.file(
        "extdata", "schema",
        package = "workflow.pacta.webapp"
        ),
      "portfolioParameters.json"
    )
  )
)
invisible(
  file.copy(
    from = system.file(
      "extdata", "schema", "reportingParameters.json",
      package = "workflow.pacta.report"
      ),
    to = file.path(
      system.file(
        "extdata", "schema",
        package = "workflow.pacta.webapp"
        ),
      "reportingParameters.json"
    )
  )
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

manifest_info <- workflow.pacta::run_pacta(params)

pacta.workflow.utils::export_manifest(
  input_files = manifest_info[["input_files"]],
  output_files = manifest_info[["output_files"]],
  params = manifest_info[["params"]],
  manifest_path = file.path(Sys.getenv("ANALYSIS_OUTPUT_DIR"), "manifest.json"),
  raw_params = raw_params
)

report_manifest_info <- workflow.pacta.report:::run_pacta_reporting_process(
  params = params
)

pacta.workflow.utils::export_manifest(
  input_files = report_manifest_info[["input_files"]],
  output_files = report_manifest_info[["output_files"]],
  params = report_manifest_info[["params"]],
  manifest_path = file.path(Sys.getenv("REPORT_OUTPUT_DIR"), "manifest.json"),
  raw_params = raw_params
)
