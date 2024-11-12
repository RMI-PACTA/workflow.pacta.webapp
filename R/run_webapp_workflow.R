run_webapp_workflow <- function(
  params,
  raw_params,
  run_analysis = TRUE,
  run_reporting = TRUE
) {

  analysis_manifest_path <- file.path(
    Sys.getenv("ANALYSIS_OUTPUT_DIR"),
    "manifest.json"
  )
  reporting_manifest_path <- file.path(
    Sys.getenv("REPORTING_OUTPUT_DIR"),
    "manifest.json"
  )

  if (run_analysis || !file.exists(analysis_manifest_path)) {

    analysis_manifest_info <- workflow.pacta::run_pacta(params)

    pacta.workflow.utils::export_manifest(
      input_files = analysis_manifest_info[["input_files"]],
      output_files = analysis_manifest_info[["output_files"]],
      params = analysis_manifest_info[["params"]],
      manifest_path = analysis_manifest_path,
      raw_params = raw_params
    )

  }

  if (run_reporting) {

    report_manifest_info <- workflow.pacta.report:::run_pacta_reporting_process(
      params = params
    )

    pacta.workflow.utils::export_manifest(
      input_files = report_manifest_info[["input_files"]],
      output_files = report_manifest_info[["output_files"]],
      params = report_manifest_info[["params"]],
      manifest_path = reporting_manifest_path,
      raw_params = raw_params
    )

  }

}
