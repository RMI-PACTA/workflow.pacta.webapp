run_webapp_workflow <- function(
  params,
  run_analysis = TRUE,
  run_reporting = TRUE
  ) {

  analysis_manifest_info <- workflow.pacta::run_pacta(params)

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

}
