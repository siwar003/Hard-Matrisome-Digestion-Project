#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
})

args <- commandArgs(trailingOnly = TRUE)

stats_dir <- if (length(args) >= 1) {
  args[[1]]
} else {
  file.path("results", "filtered_onlyGallus_coverage_stats")
}

dir.create(stats_dir, recursive = TRUE, showWarnings = FALSE)

pairwise_file <- file.path(stats_dir, "pairwise_wilcox_condition_comparisons.csv")
summary_file  <- file.path(stats_dir, "condition_summary_for_stats.csv")

if (!file.exists(pairwise_file)) {
  stop("Could not find pairwise file: ", pairwise_file)
}

if (!file.exists(summary_file)) {
  stop("Could not find summary file: ", summary_file)
}

pairwise <- read_csv(pairwise_file, show_col_types = FALSE)
summary  <- read_csv(summary_file, show_col_types = FALSE)

summary_small <- summary %>%
  select(
    subset_id,
    subset_label,
    condition_label,
    median_coverage,
    mean_coverage,
    n
  )

merged <- pairwise %>%
  left_join(
    summary_small,
    by = c(
      "subset_id",
      "subset_label",
      "condition_1" = "condition_label"
    )
  ) %>%
  rename(
    condition_1_median = median_coverage,
    condition_1_mean = mean_coverage,
    condition_1_n = n
  ) %>%
  left_join(
    summary_small,
    by = c(
      "subset_id",
      "subset_label",
      "condition_2" = "condition_label"
    )
  ) %>%
  rename(
    condition_2_median = median_coverage,
    condition_2_mean = mean_coverage,
    condition_2_n = n
  ) %>%
  mutate(
    median_difference = condition_1_median - condition_2_median,
    mean_difference = condition_1_mean - condition_2_mean,

    higher_by_median = case_when(
      condition_1_median > condition_2_median ~ condition_1,
      condition_2_median > condition_1_median ~ condition_2,
      TRUE ~ "Equal median"
    ),

    lower_by_median = case_when(
      condition_1_median < condition_2_median ~ condition_1,
      condition_2_median < condition_1_median ~ condition_2,
      TRUE ~ "Equal median"
    ),

    significantly_higher = ifelse(
      significant == TRUE,
      higher_by_median,
      NA_character_
    )
  ) %>%
  arrange(subset_label, p_adj_BH)

output_file <- file.path(stats_dir, "pairwise_wilcox_with_higher_condition.csv")

write_csv(merged, output_file)

message("Wrote: ", normalizePath(output_file, winslash = "/", mustWork = TRUE))
