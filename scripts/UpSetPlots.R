# ══════════════════════════════════════════════════════════════════════════════
#  Matrisome UpSet Plots  —  per-category PNG output
#  Conditions: S, L, C, N, SF, LF, CF, RT, RTF (triplicates except RT/RTF)
# ══════════════════════════════════════════════════════════════════════════════

# ── 0.  Install / load packages ───────────────────────────────────────────────
pkgs <- c("UpSetR", "tidyverse", "tools", "grid")
new_pkgs <- pkgs[!pkgs %in% installed.packages()[, "Package"]]
if (length(new_pkgs)) install.packages(new_pkgs, repos = "https://cloud.r-project.org")
invisible(lapply(pkgs, library, character.only = TRUE))

# ── 1.  User-defined paths  ───────────────────────────────────────────────────
PROTEIN_DIR    <- "C:/Users/Siwar/Desktop/Hard Matrisome Digestion/Search_result (1)/protein/filtered_gallus"

GMT_MATRISOME  <- "C:/Users/Siwar/Downloads/NABA_MATRISOME.v2026.1.Hs.gmt"
GMT_CORE       <- "C:/Users/Siwar/Downloads/NABA_CORE_MATRISOME.v2026.1.Hs.gmt"
GMT_AFFILIATED <- "C:/Users/Siwar/Downloads/NABA_ECM_AFFILIATED.v2026.1.Hs.gmt"
GMT_REGULATORS <- "C:/Users/Siwar/Downloads/NABA_ECM_REGULATORS.v2026.1.Hs.gmt"
GMT_COLLAGENS  <- "C:/Users/Siwar/Downloads/NABA_COLLAGENS.v2026.1.Hs.gmt"
GMT_PROTEOGLYCAN <- "C:/Users/Siwar/Downloads/NABA_PROTEOGLYCANS.v2026.1.Hs.gmt"
GMT_GLYCOPROTEIN <- "C:/Users/Siwar/Downloads/NABA_ECM_GLYCOPROTEINS.v2026.1.Hs.gmt"
GMT_BASEMENT   <- "C:/Users/Siwar/Downloads/NABA_BASEMENT_MEMBRANES.v2026.1.Hs.gmt"
GMT_ASSOCIATED <- "C:/Users/Siwar/Downloads/NABA_MATRISOME_ASSOCIATED.v2026.1.Hs.gmt"

OUTPUT_DIR     <- file.path(dirname(PROTEIN_DIR), "upset_plots")
dir.create(OUTPUT_DIR, showWarnings = FALSE, recursive = TRUE)

# ── 2.  Helper: read a .gmt file → character vector of gene symbols ───────────
read_gmt <- function(path) {
  lines <- readLines(path, warn = FALSE)
  genes <- character(0)
  for (line in lines) {
    if (nchar(trimws(line)) == 0) next
    parts <- strsplit(line, "\t")[[1]]
    if (length(parts) > 2) genes <- c(genes, parts[3:length(parts)])
  }
  toupper(trimws(genes[nchar(trimws(genes)) > 0]))
}

# ── 3.  Helper: derive condition label from filename  ─────────────────────────
#   C1  → "C"   C1F → "CF"   L2F → "LF"   N4 → "N"   RT → "RT"   RTF → "RTF"
extract_condition <- function(fname) {
  base <- file_path_sans_ext(fname)
  gsub("\\d+", "", base)          # strip all digit characters
}

# ── 4.  Read protein files & pool replicates per condition ────────────────────
#   Accepted file extensions: .txt  .tsv  .csv
files <- list.files(PROTEIN_DIR,
                    pattern = "\\.(txt|tsv|csv)$",
                    full.names = TRUE,
                    ignore.case = TRUE)

if (length(files) == 0) stop("No .txt/.tsv/.csv files found in PROTEIN_DIR.")

# Candidate column names for gene identifiers (MaxQuant, FragPipe, Spectronaut …)
GENE_COL_CANDIDATES <- c(
  "Gene.names", "Gene Names", "Gene_names",
  "Genes", "Gene", "gene", "genes",
  "Gene.Name", "GeneName", "gene_name",
  "Protein.IDs", "Protein IDs", "ProteinID",
  "Majority.protein.IDs",
  "symbol", "Symbol", "SYMBOL"
)

read_genes_from_file <- function(filepath) {
  # Auto-detect separator
  first_line <- readLines(filepath, n = 1, warn = FALSE)
  sep <- if (grepl("\t", first_line)) "\t" else ","
  
  df <- tryCatch(
    read.delim(filepath, header = TRUE, sep = sep,
               stringsAsFactors = FALSE, check.names = FALSE, quote = ""),
    error = function(e) {
      warning(paste("Cannot read", basename(filepath), ":", e$message))
      return(NULL)
    }
  )
  if (is.null(df) || nrow(df) == 0) return(character(0))
  
  # Find gene column (case-insensitive match)
  col_match <- which(tolower(colnames(df)) %in% tolower(GENE_COL_CANDIDATES))
  
  if (length(col_match) == 0) {
    warning(paste0(
      "No recognised gene column in '", basename(filepath),
      "'. Columns: ", paste(colnames(df), collapse = ", "),
      "  → Using first column."
    ))
    col_use <- colnames(df)[1]
  } else {
    # Prefer exact GENE_COL_CANDIDATES order
    pref <- match(tolower(GENE_COL_CANDIDATES), tolower(colnames(df)[col_match]))
    col_use <- colnames(df)[col_match[which(!is.na(pref))[1]]]
    if (is.na(col_use)) col_use <- colnames(df)[col_match[1]]
  }
  
  raw <- as.character(df[[col_use]])
  
  # Handle semicolon-separated entries (common in MaxQuant "Gene names")
  genes <- unlist(strsplit(raw, ";"))
  genes <- toupper(trimws(genes))
  genes <- genes[!is.na(genes) & genes != "" & genes != "NA"]
  unique(genes)
}

# Build condition → pooled gene list
condition_genes <- list()
for (f in files) {
  cond  <- extract_condition(basename(f))
  genes <- read_genes_from_file(f)
  condition_genes[[cond]] <- unique(c(condition_genes[[cond]], genes))
}

# Report
cat("\n── Conditions detected ──────────────────────────────────────────────────\n")
for (cond in sort(names(condition_genes))) {
  cat(sprintf("  %-6s  %d proteins\n", cond, length(condition_genes[[cond]])))
}

# ── 5.  Load reference GMT gene sets  ────────────────────────────────────────
gmt_files <- list(
  "All Matrisome"        = GMT_MATRISOME,
  "Core Matrisome"       = GMT_CORE,
  "Matrisome Associated" = GMT_ASSOCIATED,
  "ECM Affiliated"       = GMT_AFFILIATED,
  "ECM Regulators"       = GMT_REGULATORS,
  "Collagens"            = GMT_COLLAGENS,
  "Proteoglycans"        = GMT_PROTEOGLYCAN,
  "ECM Glycoproteins"    = GMT_GLYCOPROTEIN,
  "Basement Membrane"    = GMT_BASEMENT
)

gmt_sets <- lapply(gmt_files, read_gmt)
cat("\n── GMT gene-set sizes ───────────────────────────────────────────────────\n")
for (nm in names(gmt_sets)) cat(sprintf("  %-25s  %d genes\n", nm, length(gmt_sets[[nm]])))

all_matrisome_genes <- gmt_sets[["All Matrisome"]]

# ── 6.  Desired condition display order  ──────────────────────────────────────
COND_ORDER <- c("S", "L", "C", "N", "SF", "LF", "CF", "RT", "RTF")

COND_LABELS <- c(
  "S"   = "Short heat",
  "L"   = "Long heat",
  "C"   = "Collagenase",
  "N"   = "Benchmark",
  "SF"  = "High heat/ Short heat",
  "LF"  = "High heat/ Long heat",
  "CF"  = "High heat/ Collagenase",
  "RT"  = "Cold water",
  "RTF" = "High heat/ Cold water"
)

reorder_conditions <- function(cg) {
  present <- intersect(COND_ORDER, names(cg))
  extra   <- setdiff(names(cg), COND_ORDER)
  cg[c(present, extra)]
}
condition_genes <- reorder_conditions(condition_genes)

# Drop HEK condition if present
condition_genes <- condition_genes[!grepl("^HEK", names(condition_genes), ignore.case = TRUE)]

# Rename conditions to descriptive labels
names(condition_genes) <- ifelse(
  names(condition_genes) %in% names(COND_LABELS),
  COND_LABELS[names(condition_genes)],
  names(condition_genes)
)

# ── 7.  Build binary membership matrix for UpSetR  ───────────────────────────
make_upset_df <- function(cond_gene_list) {
  # Remove empty conditions
  cond_gene_list <- cond_gene_list[sapply(cond_gene_list, length) > 0]
  if (length(cond_gene_list) < 2) return(NULL)
  
  all_proteins <- unique(unlist(cond_gene_list))
  if (length(all_proteins) == 0) return(NULL)
  
  mat <- as.data.frame(
    lapply(cond_gene_list, function(g) as.integer(all_proteins %in% g)),
    check.names = FALSE
  )
  rownames(mat) <- all_proteins
  mat
}

# ── 8.  UpSet plot theme settings  ───────────────────────────────────────────
PALETTE_BAR    <- "#2B6CB0"   # intersection bars
PALETTE_SET    <- "#C05621"   # set size bars
PALETTE_MATRIX <- "#2B6CB0"   # filled dots

plot_upset <- function(df, title_label) {
  if (is.null(df) || nrow(df) == 0) return(invisible(NULL))
  
  n_sets <- ncol(df)
  n_prot <- nrow(df)
  
  # Dynamic height for set-size panel
  mb_ratio <- if (n_sets <= 5) c(0.62, 0.38) else c(0.55, 0.45)
  
  # upset() must be wrapped in print() when called inside a function
  # or when rendering to a PNG/PDF device — otherwise the plot is blank
  print(upset(
    df,
    sets            = rev(colnames(df)),  # respect condition order
    keep.order      = TRUE,
    order.by        = "freq",
    decreasing      = TRUE,
    mb.ratio        = mb_ratio,
    text.scale = c(2.2, 2.0, 1.8, 1.8, 2.2, 1.8),
    point.size      = 3.5,
    line.size       = 1.1,
    mainbar.y.label = "Number of Shared Proteins",
    sets.x.label    = "Proteins per Condition",
    main.bar.color  = PALETTE_BAR,
    sets.bar.color  = PALETTE_SET,
    matrix.color    = PALETTE_MATRIX,
    show.numbers    = "yes",
    number.angles   = 0,
    att.pos         = "top"
  ))
  
  # Add title + total protein count (must come AFTER print())
  grid.text(
    paste0(title_label),
    x  = 0.66, y = 0.98,
    gp = gpar(fontsize = 20, fontface = "bold", col = "#1A202C")
  )
}

# ── 9.  Build category list (including Non-Matrisome)  ───────────────────────
categories <- list()

# Non-Matrisome
categories[["Non-Matrisome"]] <- lapply(
  condition_genes,
  function(g) g[!g %in% all_matrisome_genes]
)

# Each GMT category
for (nm in names(gmt_sets)) {
  categories[[nm]] <- lapply(
    condition_genes,
    function(g) intersect(g, gmt_sets[[nm]])
  )
}

# ── 10. Save PNG per category  ────────────────────────────────────────────────
cat("\n── Generating plots ─────────────────────────────────────────────────────\n")

for (cat_name in names(categories)) {
  cat_data <- categories[[cat_name]]
  
  df <- make_upset_df(cat_data)
  
  if (is.null(df)) {
    cat(sprintf("  SKIP  '%s'  — fewer than 2 conditions with proteins\n", cat_name))
    next
  }
  
  safe_name <- gsub("[^A-Za-z0-9_-]", "_", cat_name)
  out_png   <- file.path(OUTPUT_DIR, paste0("upset_", safe_name, ".png"))
  
  tryCatch({
    png(out_png, width = 2600, height = 1700, res = 200)
    plot_upset(df, cat_name)
    dev.off()
    cat(sprintf("  OK    '%s'  → %s\n", cat_name, basename(out_png)))
  }, error = function(e) {
    try(dev.off(), silent = TRUE)
    warning(sprintf("  ERROR '%s': %s\n", cat_name, e$message))
  })
}

cat("\n✔  Done!  PNGs saved to:", OUTPUT_DIR, "\n")