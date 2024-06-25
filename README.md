# workflow.pacta.webapp

R package and Corresponding Docker image for PACTA web application.

although this application can be run locally, it is primarily intended to be run as a Docker image.
These instructions document using the Docker image, and running the workflow locally is left as an exercise for the reader.

## Setup

### Prerequisite Data

Running the application requires access to a number of prepared datasets, which should be accesible to the Docker image through bind mounts.
Each of the data sets listed can live in their own directory for clarity, or they can reside in the same directory for simplicity.
The application is configured by setting the value of enironment variables to point to the path of the bind mound *as referenced inside the container* (the `target` of the volume).

- `BENCHMARKS_DIR`:
  Outputs of [`workflow.prepare.pacta.indices`](https://github.com/RMI-PACTA/workflow.prepare.pacta.indices).
  (May be read only)
- `PACTA_DATA_DIR`:
  Outputs of [`workflow.data.preparation`](https://github.com/RMI-PACTA/workflow.data.preparation).
  Note that `workflow.data.preparation` prepares data for a given holdings date (denoted by strings such as `2022Q4` or `2023Q4`), so running this application for different portfolios may require mounting different directories.
  (May be read only)
- `REAL_ESTATE_DIR`:
  (*user specific*)
  Contains prepared user real estate data results (Used as part of PA2022CH project). Frequently empty.
  *This envvar is likely to be deprecated in an upcoming version*.
  (May be read only)
- `SCORE_CARD_DIR`:
  (*user specific*)
  Contains user results for score card (Used as part of PA2024CH project). Frequently empty.
  See [workflow.prep.PA2024CH](https://github.com/RMI-PACTA/workflow.prep.PA2024CH) for more information.
  *This envvar is likely to be made optional in an upcoming version*.
  (May be read only)
- `SURVEY_DIR`:
  (*user specific*)
  Contains user survey results (Used as part of PA2024CH project). Frequently empty.
  See [workflow.prep.PA2024CH](https://github.com/RMI-PACTA/workflow.prep.PA2024CH) for more information.
  *This envvar is likely to be made optional in an upcoming version*.
  (May be read only)


### Application Config

The following environment variables must be set.

- `ANALYSIS_OUTPUT_DIR`:
  Suggested value: `/mnt/analysis_output_dir`.
  This holds the outputs from [`workflow.pacta`](https://github.com/RMI-PACTA/workflow.pacta)
  *MUST* point to a directory that is writable by the `workflow-pacta-webapp` user.
- `BENCHMARKS_DIR`:
  Suggested value: `/mnt/benchmarks_dir`.
  See [Prerequisite Data](#prerequisite-data) for interpretation.
- `OUTPUT_DIR`:
  Suggested value: `/mnt/analysis_output_dir`.
  See [Prerequisite Data](#prerequisite-data) for interpretation.
- `PACTA_DATA_DIR`:
  Suggested value: `/mnt/pacta-data`.
  See [Prerequisite Data](#prerequisite-data) for interpretation.
- `PORTFOLIO_DIR`:
  Suggested value: `/mnt/portfolios`.
  This is the directory in which portfolio `.csv` files reside.
  *Note*: The application does *not* doe a recursive search, so if the application is searching for `foo.csv` in `/mnt/bar`, then the portfolio must be at `/mnt/bar/foo.csv`, not `/mnt/bar/bax/foo.csv`
- `REAL_ESTATE_DIR`:
  Suggested value: `/mnt/real_estate_dir`.
  See [Prerequisite Data](#prerequisite-data) for interpretation.
- `REPORT_OUTPUT_DIR`:
  Suggested value: `/mnt/report_output_dir`.
  This holds the interactive report `index.html` and friends, output from [`workflow.pacta.report`](https://github.com/RMI-PACTA/workflow.pacta.report)
  *MUST* point to a directory that is writable by the `workflow-pacta-webapp` user.
  *NOTE: The application currently outputs the report to `$REPORT_OUTPUT_DIR/report/index.html`, rather than `$REPORT_OUTPUT_DIR/index.html`. This is likely to be changed in an upcoming version*.
- `SCORE_CARD_DIR`:
  Suggested value: `/mnt/score_card_dir`.
  See [Prerequisite Data](#prerequisite-data) for interpretation.
- `SUMMARY_OUTPUT_DIR`:
  Suggested value: `/mnt/summary_output_dir`.
  TODO: Write this
- `SURVEY_DIR`:
  Suggested value: `/mnt/survey_dir`.
  This holds the executive summary PDF, output from [`workflow.pacta.report`](https://github.com/RMI-PACTA/workflow.pacta.report)
  *MUST* point to a directory that is writable by the `workflow-pacta-webapp` user.
  *NOTE: The application currently outputs the report to `$SURVEY_DIR/executive_summary/*.pdf`, rather than `$SURVEY_DIR/*.pdf`. This is likely to be changed in an upcoming version*.

The following envrionment variables are *optional*

- `LOG_LEVEL`: Controls the verbosity of logging.
  Accepts standard `log4j` levels (`ERROR`, `WARN`, `INFO`, `DEBUG`, `TRACE`).
  Default is `INFO`.

## Running the Application

The easiest way to run the application is with `docker-compose up --build`.
Do note that this builds the image, which may take a long time, espescially on `arm64` (Apple Silicon) machines.
Up-to-date image can be found at the repo's [package page](https://github.com/RMI-PACTA/workflow.pacta.webapp/pkgs/container/workflow.pacta.webapp), with the `main` tag being the most reliable (stable).

The image defines a script as `ENTRYPOINT`, allowing for passing a JSON object (as `command`) which defines the portfolio, and the options with which to run the analysis.

There are many options that can control the analysis, most of which are out of scope of this document.
The simplest form (and minimal example that passes validation) for the JSON object to pass in is something along the lines of:

```json
{
  "portfolio": {
    "files": "default_portfolio.csv",
    "holdingsDate": "2023-12-31",
    "name": "FooPortfolio"
  },
  "inherit": "GENERAL_2023Q4"
}
```

Let's break that down.

`"inherit": "GENERAL_2023Q4"` is doing a lot of the heavy lifting here.
`workflow.pacta.webapp` makes use of an option inheritance engine (provided by [`pacta.workflow.utils::parse_json_params()`](https://github.com/RMI-PACTA/pacta.workflow.utils/blob/main/R/parse_json_params.R)) that allows for pre-defined configurations of reasonable defaults for most users.
Currently, The application will work properly with `GENERAL_2023Q4` or `GENERAL_2022Q4`.

The `portfolio` object has three required keys:

- `files`: The name of the CSV file with the portfolio contents.
  Note the lack of file extension.
  *NOTE: The type of this object is likely to change to `array` (even if length 1) in the near future*
- `holdingsDate`: The date for which the portfolio should be analyzed.
  Acceptable values at this time are `2022-12-31` and `2023-12-31`.
- `name`: A string defining the user-facing name for the portfolio (used in reporting).
