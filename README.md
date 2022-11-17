## Introduction
Plott is a Nextflow pipeline for genomic analysis.

## Installation
```
conda env create -f environment.yml
conda activate plott
```

## Usage

### download sketch for homopolish
```
bash scripts/fetch_mash_sketches.sh -o /path/to/dir
```
### run the assembly pipeline
```
nextflow run main.nf --long_reads /path/to/nanopore.fq --sketches /path/to/mash/sketch --out_dir /path/to/outdir -resume
```