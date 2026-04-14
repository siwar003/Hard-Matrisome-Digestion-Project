#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
  library(readr)
})

args <- commandArgs(trailingOnly = TRUE)

input_dir <- if (length(args) >= 1) {
  args[[1]]
} else {
  "C:/Users/siwar/Desktop/Mass spec/filtered_onlyGallus"
}

output_dir <- if (length(args) >= 2) {
  args[[2]]
} else {
  file.path(getwd(), "results", "filtered_onlyGallus_coverage")
}

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

message("Input directory: ", normalizePath(input_dir, winslash = "/", mustWork = TRUE))
message("Output directory: ", normalizePath(output_dir, winslash = "/", mustWork = FALSE))

condition_levels <- c(
  "Short heat",
  "High heat / Short heat",
  "Long heat",
  "High heat / Long heat",
  "Collagenase",
  "High heat / Collagenase",
  "Benchmark",
  "Cold water",
  "High heat / Cold water"
)

colour_map <- c(
  "Short heat" = "#90CAF9",
  "High heat / Short heat" = "#B71C1C",
  "Long heat" = "#90CAF9",
  "High heat / Long heat" = "#B71C1C",
  "Collagenase" = "#90CAF9",
  "High heat / Collagenase" = "#B71C1C",
  "Benchmark" = "#A5D6A7",
  "Cold water" = "#90CAF9",
  "High heat / Cold water" = "#B71C1C"
)

subset_label_map <- c(
  "NABA_MATRISOME" = "Matrisome",
  "NABA_CORE_MATRISOME" = "Core Matrisome",
  "NABA_MATRISOME_ASSOCIATED" = "Matrisome Associated",
  "NABA_BASEMENT_MEMBRANES" = "Basement Membranes",
  "NABA_COLLAGENS" = "Collagens",
  "NABA_ECM_GLYCOPROTEINS" = "ECM Glycoproteins",
  "NABA_PROTEOGLYCANS" = "Proteoglycans",
  "NABA_ECM_AFFILIATED" = "ECM Affiliated",
  "NABA_ECM_REGULATORS" = "ECM Regulators"
)

subset_order <- c(
  "NABA_MATRISOME",
  "NABA_CORE_MATRISOME",
  "NABA_MATRISOME_ASSOCIATED",
  "NABA_BASEMENT_MEMBRANES",
  "NABA_COLLAGENS",
  "NABA_ECM_GLYCOPROTEINS",
  "NABA_PROTEOGLYCANS",
  "NABA_ECM_AFFILIATED",
  "NABA_ECM_REGULATORS"
)

parse_condition <- function(sample_name) {
  sample_name <- toupper(sample_name)

  if (grepl("^RTF$", sample_name)) {
    return(c(condition_code = "RTF", condition_label = "High heat / Cold water"))
  }
  if (grepl("^RT$", sample_name)) {
    return(c(condition_code = "RT", condition_label = "Cold water"))
  }
  if (grepl("^S[1-3]F$", sample_name)) {
    return(c(condition_code = "SF", condition_label = "High heat / Short heat"))
  }
  if (grepl("^S[1-3]$", sample_name)) {
    return(c(condition_code = "S", condition_label = "Short heat"))
  }
  if (grepl("^L[1-3]F$", sample_name)) {
    return(c(condition_code = "LF", condition_label = "High heat / Long heat"))
  }
  if (grepl("^L[1-3]$", sample_name)) {
    return(c(condition_code = "L", condition_label = "Long heat"))
  }
  if (grepl("^C[1-3]F$", sample_name)) {
    return(c(condition_code = "CF", condition_label = "High heat / Collagenase"))
  }
  if (grepl("^C[1-3]$", sample_name)) {
    return(c(condition_code = "C", condition_label = "Collagenase"))
  }
  if (grepl("^N[4-6]$", sample_name)) {
    return(c(condition_code = "N", condition_label = "Benchmark"))
  }

  c(condition_code = NA_character_, condition_label = NA_character_)
}

parse_subset_id <- function(path) {
  file_name <- basename(path)
  subset_id <- sub("\\.v[0-9.]+\\.Hs(?: \\([0-9]+\\))?\\.gmt$", "", file_name, perl = TRUE)
  subset_id <- sub("\\.gmt$", "", subset_id, ignore.case = TRUE)
  subset_id
}

parse_gmt <- function(path) {
  fields <- strsplit(readLines(path, warn = FALSE), "\t")[[1]]
  unique(toupper(trimws(fields[-(1:2)])))
}

safe_bool <- function(x) {
  if (is.logical(x)) {
    return(replace(x, is.na(x), FALSE))
  }
  vals <- toupper(trimws(as.character(x)))
  vals %in% c("TRUE", "T", "1", "+", "YES")
}

sample_files <- list.files(input_dir, pattern = "\\.tsv$", full.names = TRUE, ignore.case = TRUE)
sample_files <- sample_files[grepl(
  "^(S[1-3]F?|L[1-3]F?|C[1-3]F?|N[4-6]|RTF?)\\.tsv$",
  basename(sample_files),
  ignore.case = TRUE
)]
sample_files <- sort(sample_files)

if (length(sample_files) == 0) {
  stop("No matching sample TSV files were found in: ", input_dir)
}

subset_files <- list.files(input_dir, pattern = "^NABA_.*\\.gmt$", full.names = TRUE, ignore.case = TRUE)

if (length(subset_files) == 0) {
  stop("No NABA GMT files were found in: ", input_dir)
}

subset_meta <- tibble::tibble(
  subset_file = subset_files,
  subset_id = vapply(subset_files, parse_subset_id, character(1)),
  subset_label = dplyr::recode(vapply(subset_files, parse_subset_id, character(1)), !!!subset_label_map, .default = vapply(subset_files, parse_subset_id, character(1)))
) %>%
  mutate(
    order_rank = match(subset_id, subset_order),
    order_rank = ifelse(is.na(order_rank), length(subset_order) + rank(subset_id, ties.method = "first"), order_rank)
  ) %>%
  arrange(order_rank, subset_label)

subset_membership <- lapply(seq_len(nrow(subset_meta)), function(i) {
  genes <- parse_gmt(subset_meta$subset_file[[i]])
  tibble::tibble(
    subset_id = subset_meta$subset_id[[i]],
    subset_label = subset_meta$subset_label[[i]],
    gene = genes
  )
}) %>%
  bind_rows()

subset_size_summary <- subset_membership %>%
  distinct(subset_id, subset_label, gene) %>%
  count(subset_id, subset_label, name = "genes_in_subset")

read_sample_file <- function(path) {
  sample_name <- tools::file_path_sans_ext(basename(path))
  condition_info <- parse_condition(sample_name)

  if (is.na(condition_info[["condition_code"]])) {
    return(NULL)
  }

  df <- read_tsv(path, show_col_types = FALSE, progress = FALSE)

  if ("Is Decoy" %in% names(df)) {
    df <- df[!safe_bool(df[["Is Decoy"]]), , drop = FALSE]
  }
  if ("Is Contaminant" %in% names(df)) {
    df <- df[!safe_bool(df[["Is Contaminant"]]), , drop = FALSE]
  }

  if (!all(c("Gene", "Coverage") %in% names(df))) {
    stop("The file ", basename(path), " does not contain both 'Gene' and 'Coverage' columns.")
  }

  protein_id_col <- c("Protein ID", "Protein", "Entry Name")
  protein_id_col <- protein_id_col[protein_id_col %in% names(df)]

  if (length(protein_id_col) == 0) {
    stop("The file ", basename(path), " does not contain a protein identifier column.")
  }

  protein_id_col <- protein_id_col[[1]]

  df %>%
    transmute(
      sample = sample_name,
      condition_code = condition_info[["condition_code"]],
      condition_label = condition_info[["condition_label"]],
      protein_id = toupper(trimws(as.character(.data[[protein_id_col]]))),
      gene = toupper(trimws(as.character(Gene))),
      coverage = suppressWarnings(as.numeric(Coverage))
    ) %>%
    mutate(
      protein_id = ifelse(
        is.na(protein_id) | protein_id == "",
        paste0(sample_name, "::ROW_", dplyr::row_number()),
        protein_id
      )
    ) %>%
    filter(!is.na(gene), gene != "", !is.na(coverage))
}

sample_protein_coverage <- lapply(sample_files, read_sample_file) %>%
  bind_rows() %>%
  mutate(
    condition_label = factor(condition_label, levels = condition_levels),
    sample = factor(sample, levels = unique(tools::file_path_sans_ext(basename(sample_files))))
  )

if (nrow(sample_protein_coverage) == 0) {
  stop("No usable protein coverage rows were loaded from the sample TSV files.")
}

protein_row_coverage <- sample_protein_coverage %>%
  inner_join(subset_membership, by = "gene", relationship = "many-to-many") %>%
  mutate(condition_label = factor(condition_label, levels = condition_levels))

if (nrow(protein_row_coverage) == 0) {
  stop("No overlap was found between the Gallus sample genes and the NABA subsets.")
}

condition_summary <- protein_row_coverage %>%
  group_by(subset_id, subset_label, condition_label) %>%
  summarise(
    rows_plotted = n(),
    proteins_plotted = n_distinct(protein_id),
    genes_plotted = n_distinct(gene),
    median_coverage = median(coverage, na.rm = TRUE),
    mean_coverage = mean(coverage, na.rm = TRUE),
    q1_coverage = quantile(coverage, probs = 0.25, na.rm = TRUE),
    q3_coverage = quantile(coverage, probs = 0.75, na.rm = TRUE),
    min_coverage = min(coverage, na.rm = TRUE),
    max_coverage = max(coverage, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  left_join(subset_size_summary, by = c("subset_id", "subset_label")) %>%
  arrange(match(subset_id, subset_order), condition_label)

matched_gene_summary <- protein_row_coverage %>%
  group_by(subset_id, subset_label) %>%
  summarise(
    matched_rows = n(),
    matched_genes = n_distinct(gene),
    matched_proteins = n_distinct(protein_id),
    .groups = "drop"
  ) %>%
  left_join(subset_size_summary, by = c("subset_id", "subset_label")) %>%
  arrange(match(subset_id, subset_order), subset_label)

write_csv(protein_row_coverage, file.path(output_dir, "protein_row_coverage_by_subset.csv"))
write_csv(condition_summary, file.path(output_dir, "condition_coverage_summary_by_subset.csv"))
write_csv(matched_gene_summary, file.path(output_dir, "subset_gene_match_summary.csv"))

base_theme <- theme_bw(base_size = 14, base_family = "sans") +
  theme(
    plot.title = element_text(size = 18, face = "bold"),
    plot.subtitle = element_text(size = 11, margin = margin(b = 10)),
    plot.caption = element_text(size = 9, colour = "grey30"),
    axis.title.x = element_blank(),
    axis.title.y = element_text(size = 14, face = "bold"),
    axis.text.x = element_text(size = 11, angle = 35, hjust = 1, colour = "black"),
    axis.text.y = element_text(size = 11, colour = "black"),
    panel.grid.major.x = element_blank(),
    legend.position = "none",
    plot.margin = margin(12, 18, 12, 12)
  )

make_plot <- function(subset_id_value) {
  plot_df <- protein_row_coverage %>%
    filter(subset_id == subset_id_value) %>%
    mutate(condition_label = factor(condition_label, levels = condition_levels))

  subset_info <- matched_gene_summary %>%
    filter(subset_id == subset_id_value) %>%
    slice(1)

  annotation_df <- plot_df %>%
    group_by(condition_label) %>%
    summarise(
      median_coverage = median(coverage, na.rm = TRUE),
      top_value = max(coverage, na.rm = TRUE),
      .groups = "drop"
    )

  y_span <- diff(range(plot_df$coverage, na.rm = TRUE))
  if (!is.finite(y_span) || y_span == 0) {
    y_span <- 5
  }

  annotation_df <- annotation_df %>%
    mutate(
      y = top_value + (0.06 * y_span),
      label = sprintf("%.1f%%", median_coverage)
    )

  ggplot(plot_df, aes(x = condition_label, y = coverage, fill = condition_label)) +
    geom_boxplot(
      width = 0.62,
      linewidth = 0.5,
      colour = "grey20",
      outlier.shape = 16,
      outlier.size = 1.1,
      outlier.alpha = 0.30
    ) +
    geom_text(
      data = annotation_df,
      aes(x = condition_label, y = y, label = label),
      vjust = 0,
      size = 4.0,
      fontface = "bold",
      colour = "grey15",
      inherit.aes = FALSE
    ) +
    scale_fill_manual(values = colour_map, drop = FALSE) +
    scale_x_discrete(drop = FALSE) +
    scale_y_continuous(
      labels = function(x) sprintf("%s%%", format(round(x, 1), trim = TRUE)),
      expand = expansion(mult = c(0.03, 0.14))
    ) +
    coord_cartesian(clip = "off") +
    labs(
      title = paste0(subset_info$subset_label, " Sequence Coverage"),
      y = "Sequence coverage (%)"
      
    ) +
    base_theme
}

pdf_path <- file.path(output_dir, "filtered_onlyGallus_ecm_coverage_boxplots.pdf")

if (capabilities("cairo")) {
  grDevices::cairo_pdf(pdf_path, width = 12, height = 8.5)
} else {
  grDevices::pdf(pdf_path, width = 12, height = 8.5, useDingbats = FALSE)
}

for (subset_id_value in subset_meta$subset_id) {
  print(make_plot(subset_id_value))
}

invisible(dev.off())

message("Wrote PDF: ", normalizePath(pdf_path, winslash = "/", mustWork = TRUE))
message("Wrote CSV summaries to: ", normalizePath(output_dir, winslash = "/", mustWork = TRUE))
