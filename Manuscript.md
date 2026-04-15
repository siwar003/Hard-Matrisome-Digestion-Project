# Hard Matrisome Digestion Manuscript

## Introduction

The extracellular matrix (ECM) is an intricate network of large, heavily crosslinked proteins that provide tissue mechanical support and regulate cellular processes including migration, adhesion, polarization, differentiation, and apoptosis. Alterations in ECM composition and architecture are strongly implicated in cancer metastasis and other diseases. Therefore, accurate characterization of the ECM is crucial, and bottom-up proteomics has emerged as a powerful tool for profiling and quantifying ECM components.

Because of extensive crosslinking and the rigid triple-helical structure of collagens, ECM proteins are difficult to solubilize and digest. Most existing protocols rely on harsh chemical treatments and detergents. Here, we explore a chemical-free, heat-based approach to enhance ECM accessibility.

---

## Results

### Solubilization efficiency

Solubilization efficiency increased with heat intensity. The highest solubilization (~89.6%) was observed in heat-treated collagenase samples, while the lowest (~30.3%) occurred in non-heated short incubations.

The analysis for solubilization efficiency was performed using:

`scripts/solubility_analysis.R`

---

### PSM enrichment

#### Table 2. Total and Matrisome PSMs by condition

| Condition               | Total PSMs | Matrisome PSMs | Enrichment (%) |
| ----------------------- | ---------- | -------------- | -------------- |
| Collagenase             | 579        | 293            | 50.6           |
| High heat / Collagenase | 296        | 208            | 70.3           |
| Short heat              | 1388       | 1225           | 88.3           |
| High heat / Short heat  | 1299       | 1240           | 95.5           |
| Long heat               | 1741       | 1426           | 81.9           |
| High heat / Long heat   | 1252       | 1184           | 94.6           |
| Benchmark               | 2623       | 1748           | 66.6           |

The benchmark condition yielded the highest number of Matrisome PSMs, while pre-heating conditions produced the highest enrichment percentages.

The stacked bar chart (Figure 3a) was generated using:

`scripts/psm_enrichment_stacked_bar.R`

![PSM enrichment](../figures/fig3a_psm.png)

---

### Razor intensity enrichment

Razor intensity-based enrichment confirmed that heat-treated and benchmark conditions showed high Matrisome enrichment, while collagenase samples exhibited lower enrichment and higher variability.

Figure 3b was generated using:

`scripts/matrisome_intensity_enrichment.R`

![Intensity enrichment](../figures/fig3b_intensity.png)

---

### Sequence coverage

Sequence coverage was calculated to evaluate protein identification depth.

#### Table 3. Median sequence coverage (%)

| Subset         | Short Heat | High Heat / Short Heat | Benchmark |
| -------------- | ---------- | ---------------------- | --------- |
| Core Matrisome | 17.5       | 17.4                   | 16.7      |
| Collagens      | 29.1       | 26.6                   | 30.9      |

This table was generated using:

`scripts/sequence_coverage_analysis.R`

The sequence coverage plots (Figure 4) were generated using:

`scripts/sequence_coverage_plots.R`

![Sequence coverage](../figures/fig4_sequence_coverage.png)

---

## Discussion

Heat-based methods demonstrated strong enrichment for collagen and efficient removal of non-ECM proteins. This suggests that heat may act as an effective decellularization mechanism by disrupting cellular proteins while preserving collagen structure.

However, this method introduces a bias toward collagen and may limit detection of broader Matrisome components.

---

## Conclusion

We developed a chemical-free heat-based method that achieves strong ECM enrichment and high collagen sequence coverage. This approach is simple, cost-effective, and particularly suited for collagen-rich tissues.

---

## Methods

### Workflow overview

![Workflow](../figures/fig_workflow.png)

### Data processing

All data processing and analysis were performed using R scripts located in the `scripts/` directory. Each figure corresponds to a specific script, as referenced in the Results section.

---

## Repository structure

```
.
├── manuscript/
│   └── Manuscript.md
├── scripts/
├── figures/
└── data/
```

---

## Notes

* Figures are stored in the `figures/` directory and referenced using relative paths.
* Analysis scripts are stored in the `scripts/` directory.
* This document is designed to be easily viewable on GitHub without requiring R or RStudio.
