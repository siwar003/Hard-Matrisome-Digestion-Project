library(ggplot2)
library(dplyr)
library(tidyr)

# ── Data ──────────────────────────────────────────────────────────────────────
data <- data.frame(
  Condition      = c("Collagenase", "High heat /\nCollagenase",
                     "Short heat",  "High heat /\nShort heat",
                     "Long heat",   "High heat /\nLong heat",
                     "Benchmark"),
  Total          = c(579,  296,  1388, 1299, 1741, 1252, 2623),
  Matrisome      = c(293,  208,  1225, 1240, 1426, 1184, 1748),
  Group          = c("No high heat", "High heat",
                     "No high heat", "High heat",
                     "No high heat", "High heat",
                     "Benchmark")
)

data <- data %>%
  mutate(
    Non_matrisome = Total - Matrisome,
    Condition     = factor(Condition, levels = Condition)   # preserve order
  )

# ── Reshape to long format ────────────────────────────────────────────────────
data_long <- data %>%
  select(Condition, Group, Matrisome, Non_matrisome) %>%
  pivot_longer(cols = c(Non_matrisome, Matrisome),
               names_to  = "Fraction",
               values_to = "PSMs") %>%
  mutate(
    # Unique fill key per group × fraction combination
    Fill_key = case_when(
      Group == "No high heat" & Fraction == "Non_matrisome" ~ "blue_dark",
      Group == "No high heat" & Fraction == "Matrisome"     ~ "blue_light",
      Group == "High heat"    & Fraction == "Non_matrisome" ~ "red_dark",
      Group == "High heat"    & Fraction == "Matrisome"     ~ "red_light",
      Group == "Benchmark"    & Fraction == "Non_matrisome" ~ "green_dark",
      Group == "Benchmark"    & Fraction == "Matrisome"     ~ "green_light"
    ),
    # Stack order: Non_matrisome on bottom, Matrisome on top
    Fraction = factor(Fraction, levels = c("Non_matrisome", "Matrisome"))
  )

# ── Colour palette ────────────────────────────────────────────────────────────
fill_colours <- c(
  blue_dark   = "#1565C0",   # deep blue  – no-high-heat base
  blue_light  = "#90CAF9",   # light blue – matrisome proportion
  red_dark    = "#B71C1C",   # deep red   – high-heat base
  red_light   = "#EF9A9A",   # light red  – matrisome proportion
  green_dark  = "#2E7D32",   # deep green – benchmark base
  green_light = "#A5D6A7"    # light green– matrisome proportion
)

fill_labels <- c(
  blue_dark   = "Non-matrisome (no high heat)",
  blue_light  = "Matrisome (no high heat)",
  red_dark    = "Non-matrisome (high heat)",
  red_light   = "Matrisome (high heat)",
  green_dark  = "Non-matrisome (benchmark)",
  green_light = "Matrisome (benchmark)"
)

# ── Label data frames ─────────────────────────────────────────────────────────
# Label for matrisome PSMs: placed in the middle of the light (top) segment
labels_matrisome <- data %>%
  mutate(label_y = Matrisome / 2)   # midpoint of the matrisome segment

# Label for total PSMs: placed just above the top of the bar
labels_total <- data %>%
  mutate(label_y = Total + max(Total) * 0.02)  # slight offset above bar top

# ── Plot ──────────────────────────────────────────────────────────────────────
p <- ggplot(data_long,
            aes(x    = Condition,
                y    = PSMs,
                fill = Fill_key)) +
  geom_bar(stat     = "identity",
           position = "stack",
           width    = 0.65,
           colour   = "white",
           linewidth = 0.4) +
  # Matrisome PSM label – inside the light segment
  geom_text(data    = labels_matrisome,
            aes(x   = Condition,
                y   = label_y,
                label = Matrisome),
            inherit.aes = FALSE,
            size        = 3.3,
            fontface    = "bold",
            colour      = "grey20") +
  # Total PSM label – above the bar
  geom_text(data    = labels_total,
            aes(x   = Condition,
                y   = label_y,
                label = Total),
            inherit.aes = FALSE,
            size        = 3.3,
            fontface    = "bold",
            colour      = "grey20") +
  scale_fill_manual(values = fill_colours,
                    labels = fill_labels,
                    name   = NULL,
                    breaks = c("blue_dark","blue_light",
                               "red_dark", "red_light",
                               "green_dark","green_light")) +
  # Expand y-axis so "total" labels don't get clipped
  scale_y_continuous(expand = expansion(mult = c(0, 0.08))) +
  labs(
    title    = "Total PSMs with Matrisome Fraction per Condition",
    subtitle = "Lighter shading indicates matrisome PSMs; labels show matrisome (inside) and total (above) PSMs",
    x        = NULL,
    y        = "PSMs"
  ) +
  theme_classic(base_size = 13) +
  theme(
    plot.title       = element_text(face = "bold", size = 14, hjust = 0.5),
    plot.subtitle    = element_text(size = 9, hjust = 0.5, colour = "grey40"),
    axis.text.x      = element_text(size = 10, colour = "black"),
    axis.text.y      = element_text(size = 10),
    legend.position  = "right",
    legend.text      = element_text(size = 9),
    legend.key.size  = unit(0.5, "cm"),
    panel.grid.major.y = element_line(colour = "grey90", linewidth = 0.4)
  )

# ── Save ──────────────────────────────────────────────────────────────────────
ggsave("psm_stacked_bar.png", plot = p,
       width = 9, height = 6, dpi = 300)

message("✅  Plot saved as psm_stacked_bar.png")
