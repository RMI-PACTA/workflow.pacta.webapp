#! /bin/sh

echo "$@"

Rscript --vanilla /workflow.pacta.webapp/inst/extdata/scripts/run_pacta.R "$@"

