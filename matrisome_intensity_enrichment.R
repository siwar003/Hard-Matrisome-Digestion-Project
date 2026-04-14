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
  file.path(getwd(), "results", "filtered_onlyGallus_matrisome_razor_intensity")
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

intensity_col_name <- "Razor Intensity"
intensity_slug <- "razor_intensity"

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

safe_bool <- function(x) {
  if (is.logical(x)) {
    return(replace(x, is.na(x), FALSE))
  }
  vals <- toupper(trimws(as.character(x)))
  vals %in% c("TRUE", "T", "1", "+", "YES")
}

parse_gmt <- function(path) {
  fields <- strsplit(readLines(path, warn = FALSE), "\t")[[1]]
  unique(toupper(trimws(fields[-(1:2)])))
}

gene_field_matches <- function(gene_field, gene_set) {
  if (is.na(gene_field) || trimws(gene_field) == "") {
    return(FALSE)
  }

  genes <- unlist(strsplit(toupper(gene_field), "[;,]"))
  genes <- trimws(genes)
  any(genes %in% gene_set)
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

matrisome_gmt_candidates <- sort(list.files(
  input_dir,
  pattern = "^NABA_MATRISOME.*\\.gmt$",
  full.names = TRUE,
  ignore.case = TRUE
))

if (length(matrisome_gmt_candidates) == 0) {
  stop("No NABA_MATRISOME GMT file was found in: ", input_dir)
}

matrisome_gmt <- matrisome_gmt_candidates[[1]]
matrisome_genes <- parse_gmt(matrisome_gmt)

message("Using GMT file: ", normalizePath(matrisome_gmt, winslash = "/", mustWork = TRUE))
message("Matrisome genes loaded: ", length(matrisome_genes))

read_sample_file <- function(path) {
  sample_name <- tools::file_path_sans_ext(basename(path))
  condition_info <- parse_condition(sample_name)

  if (is.na(condition_info[["condition_code"]])) {
    return(NULL)
  }

  df <- read_tsv(path, show_col_types = FALSE, progress = FALSE)

  required_cols <- c("Gene", intensity_col_name)
  if (!all(required_cols %in% names(df))) {
    stop("The file ", basename(path), " does not contain both 'Gene' and '", intensity_col_name, "' columns.")
  }

  if ("Is Decoy" %in% names(df)) {
    df <- df[!safe_bool(df[["Is Decoy"]]), , drop = FALSE]
  }
  if ("Is Contaminant" %in% names(df)) {
    df <- df[!safe_bool(df[["Is Contaminant"]]), , drop = FALSE]
  }

  protein_id <- if ("Protein ID" %in% names(df)) {
    as.character(df[["Protein ID"]])
  } else if ("Protein" %in% names(df)) {
    as.character(df[["Protein"]])
  } else {
    paste0(sample_name, "::ROW_", seq_len(nrow(df)))
  }

  out <- tibble::tibble(
    sample = sample_name,
    condition_code = condition_info[["condition_code"]],
    condition_label = condition_info[["condition_label"]],
    protein_id = toupper(trimws(protein_id)),
    gene_field = toupper(trimws(as.character(df[["Gene"]]))),
    intensity = suppressWarnings(as.numeric(df[[intensity_col_name]]))
  ) %>%
    mutate(
      protein_id = ifelse(
        is.na(protein_id) | protein_id == "",
        paste0(sample_name, "::ROW_", dplyr::row_number()),
        protein_id
      ),
      is_matrisome = vapply(gene_field, gene_field_matches, logical(1), gene_set = matrisome_genes)
    ) %>%
    filter(!is.na(intensity), intensity > 0)

  if (nrow(out) == 0) {
    return(NULL)
  }

  out
}

all_rows <- lapply(sample_files, read_sample_file) %>%
  bind_rows() %>%
  mutate(condition_label = factor(condition_label, levels = condition_levels))

if (nrow(all_rows) == 0) {
  stop("No usable intensity rows were loaded from the sample TSV files.")
}

sample_summary <- all_rows %>%
  group_by(sample, condition_code, condition_label) %>%
  mutate(
    sample_total_intensity = sum(intensity, na.rm = TRUE),
    normalized_intensity = intensity / sample_total_intensity
  ) %>%
  summarise(
    proteins_detected = n(),
    matrisome_rows = sum(is_matrisome, na.rm = TRUE),
    sample_total_intensity = first(sample_total_intensity),
    matrisome_total_intensity = sum(intensity[is_matrisome], na.rm = TRUE),
    percent_matrisome_intensity = 100 * sum(normalized_intensity[is_matrisome], na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(condition_label, sample)

condition_summary <- sample_summary %>%
  group_by(condition_label) %>%
  summarise(
    n_samples = n(),
    mean_percent_matrisome = mean(percent_matrisome_intensity, na.rm = TRUE),
    sd_percent_matrisome = ifelse(n() > 1, sd(percent_matrisome_intensity, na.rm = TRUE), NA_real_),
    min_percent_matrisome = min(percent_matrisome_intensity, na.rm = TRUE),
    max_percent_matrisome = max(percent_matrisome_intensity, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(condition_label = factor(condition_label, levels = condition_levels)) %>%
  arrange(condition_label)

write_csv(sample_summary, file.path(output_dir, paste0("sample_matrisome_", intensity_slug, "_enrichment.csv")))
write_csv(condition_summary, file.path(output_dir, paste0("condition_matrisome_", intensity_slug, "_enrichment_summary.csv")))

label_df <- condition_summary %>%
  mutate(
    label_base = ifelse(
      is.na(sd_percent_matrisome),
      sprintf("%.2f%%\nSD NA", mean_percent_matrisome),
      sprintf("%.2f%%\nSD %.2f", mean_percent_matrisome, sd_percent_matrisome)
    ),
    y_top = ifelse(
      is.na(sd_percent_matrisome),
      mean_percent_matrisome,
      mean_percent_matrisome + sd_percent_matrisome
    )
  )

y_span <- diff(range(c(
  condition_summary$mean_percent_matrisome,
  sample_summary$percent_matrisome_intensity
), na.rm = TRUE))
if (!is.finite(y_span) || y_span == 0) {
  y_span <- 5
}

label_df <- label_df %>%
  mutate(y = y_top + (0.07 * y_span))

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

plot_obj <- ggplot(condition_summary, aes(x = condition_label, y = mean_percent_matrisome, fill = condition_label)) +
  geom_col(width = 0.68, colour = "grey20", linewidth = 0.5) +
  geom_errorbar(
    data = condition_summary %>% filter(!is.na(sd_percent_matrisome)),
    aes(
      ymin = pmax(mean_percent_matrisome - sd_percent_matrisome, 0),
      ymax = mean_percent_matrisome + sd_percent_matrisome
    ),
    width = 0.16,
    linewidth = 0.6,
    colour = "grey15"
  ) +
  geom_point(
    data = sample_summary,
    aes(x = condition_label, y = percent_matrisome_intensity),
    inherit.aes = FALSE,
    position = position_jitter(width = 0.10, height = 0),
    shape = 21,
    size = 2.8,
    stroke = 0.6,
    fill = "white",
    colour = "grey15"
  ) +
  geom_text(
    data = label_df,
    aes(x = condition_label, y = y, label = label_base),
    inherit.aes = FALSE,
    vjust = 0,
    size = 3.7,
    fontface = "bold",
    lineheight = 0.95,
    colour = "grey15"
  ) +
  scale_fill_manual(values = colour_map, drop = FALSE) +
  scale_x_discrete(drop = FALSE) +
  scale_y_continuous(
    labels = function(x) sprintf("%s%%", format(round(x, 2), trim = TRUE)),
    expand = expansion(mult = c(0.03, 0.20))
  ) +
  coord_cartesian(clip = "off") +
  labs(
    title = "Matrisome Enrichment by Normalized Razor Intensity",
    subtitle = paste0(
      "NABA_MATRISOME genes; each sample was normalized so total razor intensity sums to 100%. ",
      "Bars show condition means, error bars show SD, and points show individual samples."
    ),
    y = "Matrisome razor intensity enrichment (%)",
    caption = "Single-sample controls (RT, RTF) have undefined SD and are labeled as SD NA."
  ) +
  base_theme

pdf_path <- file.path(output_dir, paste0("filtered_onlyGallus_matrisome_", intensity_slug, "_enrichment.pdf"))
png_path <- file.path(output_dir, paste0("filtered_onlyGallus_matrisome_", intensity_slug, "_enrichment.png"))

if (capabilities("cairo")) {
  ggsave(pdf_path, plot_obj, width = 12, height = 8.5, device = cairo_pdf)
} else {
  ggsave(pdf_path, plot_obj, width = 12, height = 8.5, device = grDevices::pdf)
}

ggsave(png_path, plot_obj, width = 12, height = 8.5, dpi = 300)

message("Wrote PDF: ", normalizePath(pdf_path, winslash = "/", mustWork = TRUE))
message("Wrote PNG: ", normalizePath(png_path, winslash = "/", mustWork = TRUE))
message("Wrote CSV summaries to: ", normalizePath(output_dir, winslash = "/", mustWork = TRUE))
