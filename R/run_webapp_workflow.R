#' Run Webapp workflow
#'
#' Reun steps required to prepare a PACTA analysis and report.
#'
#' @param params (`list`) A list of parameters to be used in the analysis and
#' reporting process. See JSON Schema for details.
#' @param raw_params (`character`) Raw JSON string of parameters.
#' @param run_audit (`logical`) Run the audit process.
#' @param run_analysis (`logical`) Run the analysis process.
#' @param run_reporting (`logical`) Run the reporting process.
#' @param analysis_output_dir Directory containing the PACTA analysis results.
#' @param benchmarks_dir Directory containing the benchmark analysis results.
#' @param pacta_data_dir filepath: Directory with "pacta-data"
#' @param portfolio_dir filepath: Directory with portfolio files
#' @param real_estate_dir Directory containing real estate data.
#' @param report_output_dir Directory where the interactive report will be
#' @param score_card_dir Directory containing score card data.
#' @param summary_output_dir Directory where the executive summary will be
#' @param survey_dir Directory containing survey data.
#' saved.
#' saved.
#' @return (invisible) `TRUE` if the workflow was successful. Primarily called
#' for side effect of rendering files.
#' @export
run_webapp_workflow <- function(
  params,
  raw_params,
  run_audit = TRUE,
  run_analysis = TRUE,
  run_reporting = TRUE,
  analysis_output_dir = Sys.getenv("ANALYSIS_OUTPUT_DIR"),
  benchmarks_dir = Sys.getenv("BENCHMARKS_DIR"),
  pacta_data_dir = Sys.getenv("PACTA_DATA_DIR"),
  portfolio_dir = Sys.getenv("PORTFOLIO_DIR"),
  real_estate_dir = Sys.getenv("REAL_ESTATE_DIR"),
  report_output_dir = Sys.getenv("REPORT_OUTPUT_DIR"),
  score_card_dir = Sys.getenv("SCORE_CARD_DIR"),
  summary_output_dir = Sys.getenv("SUMMARY_OUTPUT_DIR"),
  survey_dir = Sys.getenv("SURVEY_DIR")
) {

  analysis_manifest_path <- file.path(
    analysis_output_dir,
    "manifest.json"
  )
  reporting_manifest_path <- file.path(
    report_output_dir,
    "manifest.json"
  )

  if (run_audit || run_analysis || !file.exists(analysis_manifest_path)) {

    analysis_manifest_info <- workflow.pacta::run_pacta(
      params = params,
      run_audit = run_audit,
      run_analysis = run_analysis,
      pacta_data_dir = pacta_data_dir,
      output_dir = analysis_output_dir,
      portfolio_dir = portfolio_dir
    )

    pacta.workflow.utils::export_manifest(
      input_files = analysis_manifest_info[["input_files"]],
      output_files = analysis_manifest_info[["output_files"]],
      params = analysis_manifest_info[["params"]],
      manifest_path = analysis_manifest_path,
      raw_params = raw_params
    )

  }

  if (run_reporting) {

    report_manifest_info <- workflow.pacta.report::run_pacta_reporting_process(
      params = params,
      analysis_output_dir = analysis_output_dir,
      benchmarks_dir = benchmarks_dir,
      report_output_dir = report_output_dir,
      summary_output_dir = summary_output_dir,
      real_estate_dir = real_estate_dir,
      survey_dir = survey_dir,
      score_card_dir = score_card_dir
    )

    pacta.workflow.utils::export_manifest(
      input_files = report_manifest_info[["input_files"]],
      output_files = report_manifest_info[["output_files"]],
      params = report_manifest_info[["params"]],
      manifest_path = reporting_manifest_path,
      raw_params = raw_params
    )

  }
  return(invisible(TRUE))
}
