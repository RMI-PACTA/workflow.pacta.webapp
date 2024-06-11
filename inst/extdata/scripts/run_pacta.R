logger::log_threshold(Sys.getenv("LOG_LEVEL", "WARN"))
cat(commandArgs(trailingOnly = TRUE))
workflow.pacta:::run_pacta(commandArgs(trailingOnly = TRUE))
workflow.pacta.report:::run_pacta_reporting_process(
  commandArgs(trailingOnly = TRUE)
)
