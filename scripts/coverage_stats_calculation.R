#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
  library(tidyr)
  library(purrr)
  library(broom)
})

# -----------------------------
# Paths
# -----------------------------

input_csv <- "C:/Users/siwar/Desktop/filtered_onlyGallus_coverage_results/protein_row_coverage_by_subset.csv"

output_dir <- "C:/Users/siwar/Desktop/filtered_onlyGallus_coverage_stats"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

# -----------------------------
# Load data
# -----------------------------

df <- read_csv(input_csv, show_col_types = FALSE)

# Make sure coverage is numeric
df <- df %>%
  mutate(
    coverage = as.numeric(coverage),
    condition_label = as.factor(condition_label),
    subset_label = as.factor(subset_label)
  ) %>%
  filter(!is.na(coverage), !is.na(condition_label), !is.na(subset_label))

# -----------------------------
# 1. Overall test per ECM subset
# Kruskal-Wallis asks:
# "Are any conditions significantly different within this subset?"
# -----------------------------

kruskal_results <- df %>%
  group_by(subset_id, subset_label) %>%
  group_modify(~ {
    test <- kruskal.test(coverage ~ condition_label, data = .x)
    
    tibble(
      statistic = unname(test$statistic),
      p_value = test$p.value
    )
  }) %>%
  ungroup() %>%
  mutate(
    p_adj_BH = p.adjust(p_value, method = "BH"),
    significant = p_adj_BH < 0.05
  )

write_csv(
  kruskal_results,
  file.path(output_dir, "overall_kruskal_wallis_by_subset.csv")
)

# -----------------------------
# 2. Pairwise comparisons
# Wilcoxon rank-sum tests compare:
# condition A vs condition B within each ECM subset
# -----------------------------

pairwise_wilcox_results <- df %>%
  group_by(subset_id, subset_label) %>%
  group_modify(~ {
    pairwise <- pairwise.wilcox.test(
      x = .x$coverage,
      g = .x$condition_label,
      p.adjust.method = "BH",
      exact = FALSE
    )
    
    as.data.frame(as.table(pairwise$p.value)) %>%
      rename(
        condition_1 = Var1,
        condition_2 = Var2,
        p_adj_BH = Freq
      ) %>%
      filter(!is.na(p_adj_BH))
  }) %>%
  ungroup() %>%
  mutate(
    significant = p_adj_BH < 0.05
  )

write_csv(
  pairwise_wilcox_results,
  file.path(output_dir, "pairwise_wilcox_condition_comparisons.csv")
)

# -----------------------------
# 3. Summary statistics per condition
# This gives mean, median, SD, SEM, etc.
# -----------------------------

condition_summary <- df %>%
  group_by(subset_id, subset_label, condition_label) %>%
  summarise(
    n = n(),
    mean_coverage = mean(coverage, na.rm = TRUE),
    median_coverage = median(coverage, na.rm = TRUE),
    sd_coverage = sd(coverage, na.rm = TRUE),
    sem_coverage = sd_coverage / sqrt(n),
    q1_coverage = quantile(coverage, 0.25, na.rm = TRUE),
    q3_coverage = quantile(coverage, 0.75, na.rm = TRUE),
    min_coverage = min(coverage, na.rm = TRUE),
    max_coverage = max(coverage, na.rm = TRUE),
    .groups = "drop"
  )

write_csv(
  condition_summary,
  file.path(output_dir, "condition_summary_for_stats.csv")
)

# -----------------------------
# 4. Optional parametric test
# ANOVA + Tukey HSD
# Use this only if you are okay assuming approximately normal distributions.
# -----------------------------

anova_results <- df %>%
  group_by(subset_id, subset_label) %>%
  group_modify(~ {
    fit <- aov(coverage ~ condition_label, data = .x)
    
    tidy(fit) %>%
      filter(term == "condition_label") %>%
      transmute(
        statistic = statistic,
        p_value = p.value
      )
  }) %>%
  ungroup() %>%
  mutate(
    p_adj_BH = p.adjust(p_value, method = "BH"),
    significant = p_adj_BH < 0.05
  )

write_csv(
  anova_results,
  file.path(output_dir, "overall_anova_by_subset_optional.csv")
)

tukey_results <- df %>%
  group_by(subset_id, subset_label) %>%
  group_modify(~ {
    fit <- aov(coverage ~ condition_label, data = .x)
    tukey <- TukeyHSD(fit)
    
    as.data.frame(tukey$condition_label) %>%
      tibble::rownames_to_column("comparison") %>%
      separate(comparison, into = c("condition_1", "condition_2"), sep = "-") %>%
      rename(
        difference = diff,
        lower_CI = lwr,
        upper_CI = upr,
        p_adj_Tukey = `p adj`
      ) %>%
      mutate(significant = p_adj_Tukey < 0.05)
  }) %>%
  ungroup()

write_csv(
  tukey_results,
  file.path(output_dir, "pairwise_tukey_condition_comparisons_optional.csv")
)

message("Done.")
message("Stats outputs written to: ", normalizePath(output_dir, winslash = "/", mustWork = TRUE))