# Heat-Based Extraction and Enrichment of Hard Matrisome Proteins from Collagen-Rich Tissue

---

## Table of Contents

- [Introduction](#introduction)
- [Results](#results)
- [Discussion](#discussion)
- [Conclusion](#conclusion)
- [Methods](#methods)
- [References](#references)

---

## Introduction

The extracellular matrix (ECM) is an intricate network of large, heavily crosslinked proteins that provide tissue mechanical support and regulate cellular migration, adhesion, polarization, differentiation, and apoptosis. The ECM contains highly insoluble core components such as fibrillar collagens and elastin, as well as basement-membrane proteins that form sheet-like structures for support. Alterations in ECM composition and architecture are strongly implicated in cancer metastasis and disease pathogenesis. Therefore, accurate characterization of the ECM is crucial for understanding disease mechanisms and for identifying therapeutic targets and strategies, and bottom-up proteomics has developed as an attractive tool to probe and quantify the ECM <sup>1,2</sup>.

Because of the extensive covalent crosslinking and rigid triple-helical structure of collagens, which are a dominant component of the ECM, the ECM is notoriously difficult to solubilize and digest for bottom-up proteomics. Specialized extraction strategies are often required to access ECM proteins (dubbed the "Matrisome"), and most protocols utilize harsh chemical extractions and detergents. Common protocols include sequential depletion of cellular proteins using buffers of varying salt concentration, detergent composition, and pH to enrich for the ECM (decellularization), the usage of photocleavable surfactants (e.g., Azo), extraction with strong denaturants such as urea, sodium dodecyl sulfate (SDS) or guanidine hydrochloride (Gnd-HCl) followed by hydroxylamine (HA), and chemical cleavage approaches such as CNBr <sup>3-5</sup>.

An underexplored approach for improving collagen accessibility is expansion of dried collagen-rich tissues through heat and rapid steam generation. It has been previously demonstrated that short-term boiling as a pre-treatment for enzymatic hydrolysis of collagen-rich tissue increases protein yield noticeably, but long-term heating at much higher temperatures remains understudied <sup>6</sup>. Microthermal studies on mouse-derived tail tendons show that residual, strongly hydrogen-bonded water in dry collagen rapidly evaporates during brief exposure to high temperatures at 150 +/- 10 °C <sup>7</sup>. Such rapid vaporization generates internal pressure that expands the porous architecture and internal surface area of certain dried collagen-rich foods in some culinary practices (e.g. fish maw, pork rinds). This technique can be leveraged in sample preparation steps to make collagen more accessible to subsequent thermal denaturation and enzymatic digestion. Subsequent, extensive hot-water incubation at 80 °C, which is above the denaturation temperature of hydrated collagen I of 65 +/- 10 °C and is the temperature at which water absorption was determined to reach its maximum for hydrated collagen <sup>8</sup>, further disrupts intramolecular hydrogen bonding and crosslinking in the triple helix, yielding lower-molecular-weight collagen fragments that are more easily solubilized, digested, and identified by mass spectrometry <sup>7,9</sup>.

Here, we describe and validate a two-step approach for enhancing ECM solubilization and enrichment by leveraging heat treatment via chemical-free means. In this protocol, a brief high-temperature expansion (via heating at 180 °C) of dried chicken-derived tendons is followed by short or prolonged soaking in hot water (80 °C) or collagenase type I (45 °C for 1 hour). We demonstrate that puffing combined with hot-water treatment and collagenase enriches for collagen proteins while reducing reliance on harsh detergents. Solubilized protein was digested using standard bottom-up proteomics techniques and analyzed by LC-MS/MS. The method is tested on chicken-derived tendon tissue, and the treatments were benchmarked to a widely-used ECM decellularization protocol that enriches the ECM via sequential depletion of proteins through incubation in various buffers. The heat-based methods achieved higher Matrisome enrichment and a comprably-high selectivity enrichment for collagens in comparison to the benchmark.

---

## Results

### Tissue preparation and heat treatment

Chicken-feet-derived tendons were dissected and washed with ice-cold PBS to remove contaminants and then dried in a lab oven to allow for rapid steam generation in subsequent heating in canola oil. The average mass of the dried tendons was 9.7 +/- 1.9 mg, and they were briefly submerged in canola oil at 180 °C on a hot plate with a magnetic stir bar for 5-10 seconds until there was rapid expansion of tissue. The temperature of 180 °C was decided after preliminary testing of puffing efficiency at different temperatures of 140 °C, 160 °C, and 180 °C. Heating at 180 °C achieved the most rapid and obvious expansion with minimal browning (Figure 1). Samples were removed as soon as possible after expansion with metal tongs to reduce instances of Maillard reactions and sample browning, which would promote crosslinking and aggregation.

<p align="center">
  <img src="../figures/tendon_before.png" width="300"/>
  <img src="../figures/tendon_after.png" width="300"/>
</p>

**Figure 1.** Photograph of dried tendons (left) before and (right) after heating in canola oil at 180 °C, demonstrating successful expansion with minimal browning.

Heat-treated tendons were then incubated in 1.5 mL chloroform under mild agitation for 45-60 minutes at room temperature to delipidate the sample and remove the bulk of surface oil. The tendons were then removed from the chloroform wash and incubated in water at either room temperature or 80 °C for 1 hour or 48 hours, according to their assigned conditions (Table 1). Collagenase-treated samples were incubated with 500 uL of 2 mg/mL (0.2% w/v) collagenase type I, to allocate approximately 1 mg of collagenase for ~10 mg of tissue for 1 hour at 45 °C <sup>10,11</sup>. The PBS buffer was also supplemented with 0.9 mM CaCl2 to stabilize collagenase activity. Samples were then centrifuged after treatment and protein precipitation using chloroform and methanol was performed.

#### Table 1. Experimental conditions

| Code | Condition | Pre-heat (180 °C) | Solvent / Enzyme | Incubation Temp | Duration |
|:----:|:----------|:------------------------:|:-----------------|:---------------:|:--------:|
| S | Short heat | No | Water | 80 °C | 1 h |
| SF | High heat / Short heat | Yes | Water | 80 °C | 1 h |
| L | Long heat | No | Water | 80 °C | 48 h |
| LF | High heat / Long heat | Yes | Water | 80 °C | 48 h |
| C | Collagenase | No | Collagenase I | 45 °C | 1 h |
| CF | High heat / Collagenase | Yes | Collagenase I | 45 °C | 1 h |
| RT | Cold water | No | Water | RT | 48 h |
| RTF | High heat / Cold water | Yes | Water | RT | 48 h |
| N | Benchmark | No | NABA Reference decellularization | -- | -- |

### Solubilization efficiency

A clear correlation was observed between the intensity of the heat treatment and the degree of tissue solubilization. Samples subject to heat treatment at 180 °C prior to incubation swelled significantly upon rehydration in their solvents. Samples subjected to extended incubation (48 h at 80 °C) exhibited complete gelatinization of the supernatant, whereas shorter incubations (1 h at 80 °C) showed only localized gelatinization immediately surrounding the tendon. The most dramatic difference in size reduction after incubation between the heated and non-heated samples occurred for the collagenase-treated samples. Samples that were heat-treated prior to collagenase treatment notably decreased in size compared to collagenase-treated samples that did not undergo heat treatment. This suggests that the combination of high-temperature expansion increased accessibility of collagenase, leading to more efficient digestion in the 1-hour incubation period.

The mass of the remaining insoluble pellet, containing cell debris and insoluble ECM proteins that did not solubilize during treatment, was compared to the original starting dry mass of the sample to calculate the average decrease in sample size. The largest degree of solubilization was achieved by the heat-treated, collagenase-treated samples, with about 89.6% of the original dry mass getting solubilized. The least efficient solubilization was achieved by the non-heat-treated, 1-hour 80 °C incubated samples, with an average of 30.3% solubilization of the original dry mass.

<p align="center">
  <img src="../figures/solubilization_efficiency.png" width="700"/>
</p>

**Figure 2.** Solubility comparison showing percentage of original dry mass solubilized for each treatment. Pre-heat treatments are shown in red; treatments without the pre-heat step are in blue.

### PSM enrichment analysis

After the supernatants were isolated, the proteins were precipitated with methanol/chloroform, and the protein pellets were re-solubilized in 8 M urea (reduced to 2M with 100 mM Tris) for overnight trypsin digestion. The  samples were then analyzed by mass spectrometry. From mass spectrometry data, the total peptide spectrum matches (PSMs) and PSMs attributed to Matrisome proteins were plotted across all conditions (Figure 3). The number of PSMs represents the number of times a peptide in each condition was matched to a spectrum during MS2, and it provides a relative measure of sample depth.

#### Table 2. Total and Matrisome PSMs by condition

| Condition | Total PSMs | Matrisome PSMs | Enrichment (%) |
|:----------|:----------:|:--------------:|:--------------:|
| Collagenase | 579 | 293 | 50.6 |
| High heat / Collagenase | 296 | 208 | 70.3 |
| Short heat | 1,388 | 1,225 | 88.3 |
| High heat / Short heat | 1,299 | 1,240 | 95.5 |
| Long heat | 1,741 | 1,426 | 81.9 |
| High heat / Long heat | 1,252 | 1,184 | 94.6 |
| Benchmark | 2,623 | 1,748 | 66.6 |

The benchmark condition yielded the highest number of Matrisome PSMs with 1,748, but conditions with the pre-heating at 180 °C step exhibited the highest *proportion* of Matrisome PSMs. The condition receiving the pre-heating step and subsequent 80 °C water incubation at 48 hours and 1 hour achieved the highest enrichment at 94.6% and 95.5%, respectively. Notably, collagenase conditions achieved the lowest enrichment with the highest degree of variability.

> **Script:** The stacked bar chart below was generated using [`../scripts/psm_enrichment_stacked_bar.R`](../scripts/psm_enrichment_stacked_bar.R)

<p align="center">
  <img src="../figures/PSM_enrichment_by_condition_bar_graph.png.png" width="700"/>
</p>

**Figure 3.** (a) Stacked bar chart showing total and Matrisome PSMs per condition. Lighter shading indicates Matrisome PSMs; labels show Matrisome (inside) and total (above) counts. (b) Percentage of protein signal originating from Matrisome proteins by Razor intensity in each treatment.

### Razor intensity enrichment

For a more accurate estimation of protein abundance, enrichment by Razor protein intensity was also examined. The heat treatments and benchmark conditions all achieved considerably high enrichment of Matrisome proteins, and consistent with the PSM calculations, collagenase samples achieved the lowest enrichment and greatest degree of variability among replicates.

> **Script:** The intensity enrichment bar chart was generated using [`../scripts/matrisome_intensity_enrichment.R`](../scripts/matrisome_intensity_enrichment.R)

### Sequence coverage

Sequence coverage, which is the percentage of a protein's amino acid sequence identified by mass spectrometry, was also measured between conditions. High sequence coverage increases identification confidence and is crucial for identifying different protein isoforms or proteoforms to more accurately capture Matrisome diversity.

#### Table 3. Median sequence coverage (%) by Matrisome subset and condition

| Subset | Short heat | HH / Short heat | Long heat | HH / Long heat | Collagenase | HH / Collagenase | Benchmark | Cold water | HH / Cold water |
|:-------|:----------:|:----------------:|:---------:|:---------------:|:-----------:|:-----------------:|:---------:|:----------:|:---------------:|
| **Core Matrisome** | 17.5 | 17.4 | 11.3 | 7.1 | 7.2 | 10.9 | 16.7 | 8.2 | 10.9 |
| **Matrisome Associated** | 7.8 | 10.4 | 9.1 | 8.1 | 6.2 | 4.1 | 16.3 | 17.2 | -- |
| **Collagens** | 29.1 | 26.5 | 21.7 | 24.9 | 16.1 | 13.6 | 30.9 | 7.7 | 10.9 |
| **Proteoglycans** | 8.8 | 9.2 | 7.1 | 8.4 | 4.2 | 10.3 | 19.8 | 24.5 | -- |
| **ECM Glycoproteins** | 6.2 | 1.4 | 5.9 | 2.8 | 5.5 | 6.7 | 9.0 | 12.2 | -- |
| **Basement Membranes** | 0.7 | 1.4 | 2.9 | 3.8 | 3.5 | 4.1 | 4.7 | 5.6 | -- |
| **ECM Affiliated** | 3.7 | 9.0 | 7.4 | 9.0 | 4.3 | 3.4 | 23.4 | 30.1 | -- |
| **ECM Regulators** | 5.7 | 5.8 | 9.1 | 5.8 | 3.1 | 3.1 | 12.4 | 9.9 | -- |

*HH = High heat (pre-heating at 180 °C). "--" indicates no proteins detected in that subset for that condition.*

The treatments with the highest median sequence coverage for core Matrisome proteins were the short heat treatments, with and without the pre-heating step, at 17.4-17.5%. This number is closely followed by the benchmark at 16.7%. For non-core Matrisome proteins, the benchmark outperformed all other conditions in capturing the broader Matrisome, achieving a median sequence coverage of 19.9%.

Taking a closer look at the median sequence coverage values for the groups composing the Core Matrisome, heat treatments seem to be significantly biased towards collagen coverage and are selectively enriching for collagen much more efficiently than all other core Matrisome and non-core Matrisome proteins. The median sequence coverage for collagen achieved by the short heat treatments was 26.5-29.1%, competing with the benchmark's sequence coverage value of 30.9%. The long heat treatment also achieved high collagen sequence coverage at 21.7% and 24.9% for the treatments without and with the pre-heating steps, respectively. Overall, the benchmark method achieved significantly higher sequence coverage across most matrisome categories. However, for collagens specifically, the heat-based treatments reached comparable sequence coverage to the benchmark, with no significant decrease detected for the high heat/short heat or high heat/long heat conditions.

> **Script:** All sequence coverage boxplots below were generated using [`../scripts/matrisome_coverage_boxplots.R`](../scripts/matrisome_coverage_boxplots.R)

<p align="center">
  <img src="../figures/sequence_coverage_core_matrisome.png" width="700"/>
</p>

<p align="center">
  <img src="../figures/sequence_coverage_matrisome_associated.png" width="700"/>
</p>

**Figure 4.** Sequence coverage of (a) core and (b) non-core Matrisome proteins across different conditions.

<p align="center">
  <img src="../figures/sequence_coverage_collagens.png" width="700"/>
</p>

<p align="center">
  <img src="../figures/sequence_coverage_proteoglycans.png" width="700"/>
</p>

<p align="center">
  <img src="../figures/sequence_coverage_ecm_glycoproteins.png" width="700"/>
</p>

**Figure 4 (continued).** Sequence coverage for (c) collagens, (d) proteoglycans, and (e) glycoproteins.

Looking at the sequence coverage with cold-water controls in addition to the benchmark, the presence of heat appears to prevent identification of more soluble proteins (e.g. glycoproteins) but excels in identifying more insoluble proteins such as collagens.

<p align="center">
  <img src="../figures/sequence_coverage_matrisome.png" width="700"/>
</p>

<p align="center">
  <img src="../figures/sequence_coverage_basement_membranes.png" width="700"/>
</p>

<p align="center">
  <img src="../figures/sequence_coverage_ecm_affiliated.png" width="700"/>
</p>

<p align="center">
  <img src="../figures/sequence_coverage_naba_ecm_regulators.png" width="700"/>
</p>

**Figure 5.** Sequence coverage plots including the cold water controls for additional Matrisome subsets: (a) full Matrisome, (b) basement membranes, (c) ECM affiliated, and (d) ECM regulators.

### NABA Reference subset gene matching summary

#### Table 4. Genes matched per NABA Reference Matrisome subset (across all conditions)

| Subset | Matched Genes | Matched Proteins | Genes in Subset | Match Rate (%) |
|:-------|:-------------:|:----------------:|:---------------:|:--------------:|
| Matrisome | 81 | 92 | 1,026 | 7.9 |
| Core Matrisome | 49 | 59 | 275 | 17.8 |
| Matrisome Associated | 32 | 33 | 751 | 4.3 |
| Basement Membranes | 8 | 9 | 40 | 20.0 |
| Collagens | 14 | 23 | 44 | 31.8 |
| ECM Glycoproteins | 26 | 27 | 196 | 13.3 |
| Proteoglycans | 9 | 9 | 35 | 25.7 |
| ECM Affiliated | 8 | 8 | 170 | 4.7 |
| ECM Regulators | 19 | 20 | 238 | 8.0 |

*Note: NABA Reference gene sets are human-derived; match rates reflect cross-species mapping to Gallus gallus.*

### Shared and unique Matrisome proteins

Across all conditions, the majority of Matrisome proteins are shared, with only a few proteins (Elastin Microfibril Interface Located Protein 2, and Fibrinogen Gamma Chain and Fibrinogen Beta Chain) being exclusive to long heat and high heat/collagenase treatments only. The benchmark had the highest number of uniquely identified proteins. Closer examination of these proteins via STRING analysis reveals that these proteins are involved in ECM organization and post-translational modification of the ECM.

> **Script:** The UpSet plots were generated using [`../scripts/UpSetPlots.R`](../scripts/UpSetPlots.R)

<p align="center">
  <img src="../figures/upset_plot_matrisome.png" width="600"/>
</p>

<p align="center">
  <img src="../figures/upset_plot_matrsiome_associated.png" width="600"/>
</p>

**Figure 6.** UpSet plots with unique and shared (A) core Matrisome and (B) Matrisome-associated proteins across conditions. Most Matrisome proteins are shared across conditions, with the most unique proteins being identified by the benchmark.

### Replicate consistency

The consistency of the heat methods was also assessed to see if the heat treatments were reproducible across different tendon tissue samples. Heatmaps showing replicate consistency and data uniformity across conditions demonstrate that most heat-based treatments, including the benchmark, produced consistent replicates.

However, collagenase-treated samples exhibited greater variability than all other conditions, likely reflecting the inherently stochastic nature of enzymatic cleavage on an insoluble, heterogeneous sample. Attempts to account for non-tryptic collagenase-generated peptides, specifically cleavages between glycine and leucine or isoleucine residues on the collagen triple helix, by reconfiguring the MS-Fragger FragPipe database search produced an intractably large search space and did not yield meaningful results. Additional sources of variability may include differences in pH, Ca2+ concentration, and uneven surface accessibility of tendon pieces across replicates. Together, these factors suggest that collagenase treatment introduces technical variability that is difficult to control, and that the water-based approach achieves more reproducible solubilization.

<p align="center">
  <img src="../figures/sample_correlation_heatmap.png" width="500"/>
</p>

**Figure 7.** Heat maps showing replicate similarity across the different conditions.

---

## Discussion

Here we explore the effects of physical puffing of dried collagen-rich tissue via rapid exposure to high heat at 180 °C paired with incubation in hot water at 80 °C for an extended time over 1 hour and 48 hours. We demonstrated that high heat exposure and the physical reconfiguration of the extracellular matrix in collagen-rich tissue, such as tendon, is heavily biased towards collagen identification and coverage.

Since the heat-based methods, especially those with the pre-heating step, achieved significantly higher PSM enrichment scores than the benchmark and significantly fewer non-Matrisome proteins, we hypothesize that the heat-based methods are more efficient at decellularizing collagen-rich tissue. This may be due to the high heat expanding the rich collagenous networks that sequester cells in the tendon tissue and to the heat effectively degrading non-ECM cellular proteins. As a result, collagens withstand the heat stress and unwind, allowing for subsequent solubilization by water and digestion via trypsin. The decellularization method seems to be merely reducing the number of non-ECM, cellular proteins (i.e. depleting them) while the heat-based methods are destroying them, preventing them from ever being detected. This may also explain why the heat-based methods achieved higher enrichment by PSMs, especially when combined with the pre-heating step, compared to the benchmark (~95% vs ~66%) but achieved comparably high enrichment by protein intensity.

Since these heat-based methods are heavily biased towards collagen, there are several applications and advantages. This method could be more useful for collagen-rich clinical samples such as different fibrosis models that are collagen-dominated. This method could also be used in biomaterial studies to solubilize collagen for use in tissue engineering. It could also be used as a method to remove collagens from the ECM to study other non-collagen ECM proteins in conjunction with decellularization to boost the identification of non-collagen Matrisome proteins since in all conditions, collagen proteins dominated the signal and masked the identification of other proteins. However, this selectivity towards collagen can be a flaw if studying the broader Matrisome to get an idea of broader Matrisome biology. Ultimately, these heat-based methods can be combined with decellularization protocols to potentially offer a wider view of the Matrisome.

An interesting visual observation in the samples that underwent the pre-heating step at 180 °C followed by a 48-hour incubation in 80 °C water is the development of a dark red insoluble pellet with a surrounding yellow web-like structure. In these samples, there was slight loss in volume. Upon contact with 8 M urea, the web-like crust seems to be a highly insoluble ECM-enriched fraction that resists heating, prolonged high-temperature aqueous incubation, and chaotropic denaturation. It may also have retained some of the solutions it was incubated in as it settled on the tube wall, sequestering the water the tendon was incubating into the wall-bound ECM gel.

The separation of this material from the darker, compact pellet may reflect differential partitioning of ECM and non-ECM components under extreme thermal processing conditions. The remaining darker pellets may contain non-ECM insoluble components, such as general cell debris, oxidized proteins, heme, myoglobin, or Maillard reaction products from the extensive exposure to high-heat conditions. As a result, the heat treatment and extensive hot water incubation seemed to have induced a physical separation of ECM from non-ECM components, strengthening the claim that the involvement of high heat promotes excellent decellularization and fractionation of the collagen-rich tissue.

---

## Conclusion

In summary, we developed and validated a purely heat-based method for the extraction of collagens from collagen-rich tissue that produced comparable sequence coverage of collagens and high enrichment of the Matrisome, with more efficient removal of non-ECM proteins. This method is cheaper than typical decellularization protocols, relatively low-effort due to the straightforward water-based extraction, largely chemical-free, works for collagen-rich stubborn tissue that is notoriously difficult to work with, and achieves very strong selective bias for collagens. This can be useful for projects that aim to compare collagen content in different samples, study very collagen-rich clinical samples (e.g. fibrosis models), and for biomaterial applications to extract collagen for purposes such as hydrogel formation or tissue engineering.

Rather than replacing any existing methodologies, this heat-based method can be used in conjunction with existing methods to get a closer look at the Matrisome beyond collagens. Using the heat-based and decellularization method in combination for collagen-rich sample decellularization can more effectively deplete the sample of non-ECM proteins and collagens to allow for the analysis of non-collagen Matrisome proteins, since Matrisome proteomics datasets are often dominated by collagens and hinder the identification and quantification of the less abundant, smaller non-collagen Matrisome proteins.

However, there are key limitations unique to this method. Due to the high use of heat (180 °C and 80 °C), Maillard reactions can cause crosslinking that reduces solubility if samples are heated for too long at 180 °C. Additionally, while bias towards collagens can be advantageous, it also limits applicability and masks the broader Matrisome. Also, although the method is primarily chemical-free, the chloroform extraction step may produce variability so other methods for delipidation prior to mass spectrometry can be employed instead.

In the future, we aim to further explore how this method preserves or alters the natural post-translational modification landscape of the Matrisome compared to chemical-based protocols. Because this method primarily relies on physical rather than chemical disruption, it may have the potential to preserve post-translational modifications more efficiently than many conventional protocols. This can be crucial for identifying various proteoforms of collagens that are relevant for disease. We also aim to test this method on non-collagen-rich, less stubborn or softer tissue and compare it to the standard decellularization protocol to further investigate whether the heat is in fact destroying non-ECM proteins selectively.

---

## Methods

<p align="center">
  <img src="../figures/schematic_of_heat_workflow.png" width="700"/>
</p>

**Figure 8.** Schematic of heat-extraction workflow.

<p align="center">
  <img src="../figures/schematic_of_benchmark_workflow.png" width="700"/>
</p>

**Figure 9.** Schematic of decellularization benchmark protocol workflow.

### Tissue procurement

Chicken-foot tendons were dissected and rinsed on ice with ice-cold PBS (1x), 70% ethanol (1x), and PBS (1x) to remove surface contaminants. Tissues were cut into 20-30 mg pieces with sterile surgical scissors, and individual weights were recorded. Samples were stored in pre-weighed low-bind 1.5 mL tubes.

### Tissue drying and preparation

Samples were dried in a laboratory oven at ~60 °C with tube caps open and tubes spaced equally apart on a metal tube holder. Each tube was weighed hourly, and when mass stabilized across two consecutive hourly measurements, the samples were removed from the oven and the final dry mass recorded.

### Tissue heat treatment (high-temperature expansion / "puffing")

After drying, half of the samples were stored at 4 °C in closed tubes, while the other half were processed by heating in oil. Approximately 150 mL of canola oil was heated in a glass beaker on a heating plate inside a fume hood. The temperature of the oil was carefully monitored during the entire duration of heating in oil using a thermocouple, and a magnetic stir bar was used to distribute heat equally. When the oil reached 180 °C, dried tendon pieces were briefly immersed (5-10 s) one at a time using metal tongs, removed immediately after rapid expansion, and blotted on lint-free paper to remove excess oil. Samples were allowed to cool to room temperature, photographed, and returned to their tubes.

### Chloroform wash and heat treatment

Before treatment in water and collagenase solution, each heated tendon was placed in 1 mL 100% chloroform in glass vials and incubated under mild agitation for 30 minutes to remove the bulk of surface oil. The tendons were then carefully removed from the glass vials, and each tendon (except for collagenase-treated samples) was then soaked in 500 uL deionized water in low-bind 1.5 mL tubes. For collagenase-treated samples, tendons were incubated with 1 mg of collagenase type I (0.1% w/v) dissolved in 500 uL PBS supplemented with 0.9 mM CaCl2 (pH 7.4). Samples were incubated according to their assigned conditions (Table 1).

### Transferring soluble fractions

After treatment, samples were centrifuged at 18,000 x g for 20 min at 4 °C. Supernatants were carefully transferred to pre-weighed, pre-labeled low-bind tubes and designated as the soluble fraction. Remaining pellets (insoluble fraction) were air-dried on a metal rack at 60 °C, and after drying, insoluble pellets were weighed and the mass recorded.

*Note:* Since some samples had a thicker gelatin layer upon cooling, they were briefly re-heated at 37 °C after centrifugation until the gelatin was warmed and liquified for transfer by pipetting into their designated tubes.

### Lipid cleanup and protein precipitation

A 150 uL aliquot of each soluble fraction was transferred to a new, pre-weighed 1.5 mL low-bind tube for protein precipitation. Methanol/chloroform precipitation and two acetone washes were performed as follows:

1. Add 4x sample volume of ice-cold methanol (600 uL). Vortex 10 s.
2. Add 1x sample volume of cold chloroform (150 uL). Vortex 10 s.
3. Add 3x sample volume of water (450 uL). Vortex 10 s, then centrifuge 1 min at 14,000 x g. A protein wafer will appear at the interphase.
4. Carefully remove and discard the upper aqueous phase without disturbing the wafer.
5. Add 4x sample volume of cold methanol (600 uL). Vortex and centrifuge 2 min at 14,000 x g to pellet proteins. Discard supernatant.
6. Air-dry pellet briefly and avoid over-drying.

### Urea solubilization

Dried protein pellets were weighed and the mass recorded. To each pellet, 50 uL of 8 M urea (in 100 mM Tris, pH 8.5) was added. Samples were vortexed and sonicated until pellets were solubilized. Larger or more stubborn pellets were incubated at 37 °C for up to 2 h under gentle agitation, or more 8 M urea was added to them.

### Protein digestion (reduction, alkylation, trypsinization)

Samples were diluted to 2 M urea by adding 100 mM Tris. TCEP was added to a final concentration of 5 mM as a reduction step, and samples were incubated at room temperature in the dark for 20 min. CAA was then added to a final concentration of 10 mM as an alkylation step and incubated at room temperature in the dark for 15 min. CaCl2 was added to a final concentration of 1 mM. Trypsin was added at a 1:50 w/w enzyme:protein ratio, using the dried pellet mass to estimate protein amount, and samples were incubated overnight (~14-18 h) at 37 °C. The digestions were quenched by adding 96% formic acid to a final concentration of 1%, and samples were loaded onto Evotips.

### LC-MS/MS and Data Processing and Database search

*More instrument and acquisition details to be added.*
Q Exactive HF Orbitrap Mass Spectrometer (Thermo Fisher Scientific) 
DIA mode
Samples run in a randomized manner to reduce batch effects 
FragPipe: 
variable mods: hydroxylation of lysine and proline, oxidation of methionine and protein N-terminal acetylation
fixed mods: carbamidomethylation of cysteine
### Solubilized protein measurement

The remaining insoluble pellets were washed with 1 mL of ice-cold acetone (-20 °C), spun down, and the acetone carefully removed. The pellets were air-dried and weighed. Using the mass of the insoluble pellets, the solubilization efficiency was calculated.

### Comparison to decellularization protocol

As a benchmark comparison, separate tendon samples were decellularized using a protocol that depletes intracellular, non-ECM proteins using buffers of varying salt concentrations and pH to achieve a final ECM-enriched pellet. The starting material was 30 mg of fresh chicken foot tendon tissue washed with ice-cold PBS in the same manner as above.

#### Benchmark extraction buffers

| Buffer | Composition |
|:-------|:------------|
| Buffer C (Cytosolic) | 10 mM HEPES (pH 7.9); 10 mM KCl; 1.5 mM MgCl2; 0.34 M sucrose; 10% glycerol |
| Buffer W (Wash) | 10 mM HEPES (pH 7.9); 10 mM KCl; 1.5 mM MgCl2; 0.34 M sucrose; 10% glycerol |
| Buffer N (Nuclear) | 20 mM HEPES (pH 7.9); 420 mM NaCl; 1.5 mM MgCl2; 0.2 mM EDTA; 20% glycerol; benzonase |
| Buffer M (Membrane) | 10 mM HEPES (pH 7.9); 10 mM KCl; 1.5 mM MgCl2; 0.34 M sucrose; 10% glycerol; 1% NP-40 |
| Buffer CS (Cytoskeletal) | 10 mM HEPES (pH 6.8); 100 mM NaCl; 1 mM MgCl2; 0.3 M sucrose; 1% SDS |

### Tissue homogenization

Three tendons weighing ~30 mg each were first cut into small pieces using sterile surgical scissors on an ice-cold plate. The tendon fragments were then further homogenized using a manual homogenizer with 150 uL of ice-cold Buffer C. Homogenization was performed until a homogeneous solution was obtained for all three samples.

### Compartment protein extraction

For the extraction of cytosolic proteins, samples with the added Buffer C were placed on a tube rotator for 20 min at 4 °C. Samples were then centrifuged at 16,000 x g for 20 min at 4 °C. After centrifuging, the supernatant was discarded.

1. The pellet was resuspended in 120 uL of Buffer W, placed on a tube rotator for 20 min at 4 °C, and then centrifuged for 20 min at 4 °C. The supernatant was discarded.
2. The pellet was resuspended in 45 uL of Buffer N supplemented with benzonase for nuclear protein extraction. Samples were placed on a tube rotator for 30 min at 4 °C, then centrifuged for 30 min at 4 °C. The centrifugation step was repeated once more, and the supernatants were discarded.
3. The pellet was resuspended in 30 uL of Buffer M for membrane protein extraction. Samples were placed on a tube rotator for 30 min at 4 °C, then centrifuged for 30 min at 4 °C. The supernatant was discarded.
4. The pellet was resuspended in 60 uL of Buffer CS for cytoskeletal protein extraction. Samples were placed on a tube rotator for 30 min at 4 °C, then centrifuged for 30 min at 4 °C. The supernatant was removed, and the pellet was resuspended in 45 uL of Buffer C, rotated for 20 min at 4 °C, centrifuged for 20 min at 4 °C, and the supernatant removed.
5. To wash off detergents, the pellet was washed in ice-cold PBS 4 times (~1 mL each, 5 min at 16,000 x g).

### Protein solubilization and digestion

The pellets were left to air dry, and the dry mass was recorded. The pellets were solubilized in 25-50 uL 8 M urea (depending on dry pellet size) at 37 °C with agitation until the pellet was no longer dissolving (no longer than 5 minutes). The concentration of urea was brought down to 2 M using 100 mM Tris prior to digestion. The equivalent of 10 μg was taken from each sample for protein digestion in the manner described above, and the digestion conditions were identical for both the benchmark and heat-dependent methods.

## Data Analysis

Write about the data analysis from the R scripts (sequence coverage, % solubilization, heatmap generation, UpSet plots, etc.)

## Statistical Analysis 

Write about the statistical analysis from the R scripts to perform pairwise analysis



---

## References

1. Yue B. Biology of the extracellular matrix: an overview. *J Glaucoma.* 2014;23(8 Suppl 1):S20-S23.
2. Naba A. Ten Years of Extracellular Matrix Proteomics: Accomplishments, Challenges, and Future Perspectives. *Mol Cell Proteomics.* 2023;22(4):100528.
3. Knott SJ, Brown KA, Josyer H, et al. *Analytical Chemistry.* 2020;92(24):15693-15698.
4. Naba A, Clauser KR, Hynes RO. Enrichment of Extracellular Matrix Proteins from Tissues and Digestion into Peptides for Mass Spectrometry Analysis. *J Vis Exp.* 2015;(101):e53057.
5. Sato et al. Proteomic Analysis of Human Tendon and Ligament: Solubilization and Analysis of Insoluble Extracellular Matrix in Connective Tissues. *J Proteome Res.* 2016;15(12):4709-4721.
6. Zhang Y, Olsen K, Grossi A, Otte J. Effect of pretreatment on enzymatic hydrolysis of bovine collagen and formation of ACE-inhibitory peptides. *Food Chem.* 2013;141(3):2343-2354.
7. Bozec L, Odlyha M. Thermal denaturation studies of collagen by microthermal analysis and atomic force microscopy. *Biophys J.* 2011;101(1):228-236.
8. Suwa Y, Nam K, Ozeki K, Kimura T, Kishida A, Masuzawa T. Thermal denaturation behavior of collagen fibrils in wet and dry environment. *J Biomed Mater Res B Appl Biomater.* 2016;104(3):538-545.
9. Mirza SP, Halligan BD, Greene AS, Olivier M. Improved method for the analysis of membrane proteins by mass spectrometry. *Physiol Genomics.* 2007;30(1):89-94.
10. Sinthusamran S, Benjakul S. Effect of drying and frying conditions on physical and chemical characteristics of fish maw from swim bladder of seabass (*Lates calcarifer*). *J Sci Food Agric.* 2015;95(15):3195-3203.
11. Wu Q, Li C, Li C, Chen H, Shuliang L. Purification and characterization of a novel collagenase from *Bacillus pumilus* Col-J. *Appl Biochem Biotechnol.* 2010;160(1):129-139.
12. Jo CH, Lim HJ, Yoon KS. Characterization of Tendon-Specific Markers in Various Human Tissues, Tenocytes and Mesenchymal Stem Cells. *Tissue Eng Regen Med.* 2019;16(2):151-159.
13. Shaik MI, Md Nor IN, Sarbon NM. Effect of Extraction Time on the Extractability and Physicochemical Properties of Pepsin-Soluble Collagen (PCS) from the Skin of Silver Catfish (*Pangasius* sp.). *Gels.* 2023;9(4):300.
