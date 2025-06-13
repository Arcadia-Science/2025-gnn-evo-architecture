# 2025-gnn-evo-architecture

[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/projects/miniconda/en/latest/)

## Purpose

The analysis in this repo processes the literature review dataset from [Borowiec et al., 2022](https://doi.org/10.1111/2041-210X.13901) ([data obtained here](https://besjournals.onlinelibrary.wiley.com/action/downloadSupplement?doi=10.1111%2F2041-210X.13901&file=mee313901-sup-0001-Supinfo.xlsx)), and produces the visuals in Figure 1 of this repos associated pub, ["Graph Neural Networks: A unifying predictive model architecture for evolutionary applications"](https://doi.org/10.57844/arcadia-e7kq-frwh).

## Installation and Setup

This repository uses conda to manage software environments and installations. You can find operating system-specific instructions for installing miniconda [here](https://docs.conda.io/projects/miniconda/en/latest/). After installing conda and [mamba](https://mamba.readthedocs.io/en/latest/), run the following command to create the pipeline run environment.

```{bash}
mamba env create -n evo_gnn_perspective --file envs/environment.yml
conda activate evo_gnn_perspective

# Install arcadiathemeR package for plotting from github
Rscript install_arcadiathemer.R
```

## Overview

### Description of the folder structure

1. `mee313901-sup-0001-supinfo.txt`: Tab-delimited data from [Borowiec et al., 2022](https://doi.org/10.1111/2041-210X.13901). Reformatted from [the original excel file](https://besjournals.onlinelibrary.wiley.com/action/downloadSupplement?doi=10.1111%2F2041-210X.13901&file=mee313901-sup-0001-Supinfo.xlsx).
2. `plot_nn_evo_pub_trends.R`: R-script used to process and plot NN usage trends as shown in Figure 1 of our associated pub.

### Methods

To run analyses, simply call the following from the commandline.

```
Rscript plot_nn_evo_pub_trends.R
```

### Compute Specifications

Analysis was originally carried out on a 2021 Macbook Pro with an Apple M1 Pro processor.
