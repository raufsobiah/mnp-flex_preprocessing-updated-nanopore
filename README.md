<div align="left">

<h1 style="display: inline-block;">Rapid-CNS2+MNPflex-nanopore</h1>
</div>

Rapid-CNS2 and MNPflex are brain/central nervous system (CNS) tumour methylation classifiers.
The fork is based on nanopore sequencing data (for cfDNA and genomic DNA) that includes 5hmC and 5mC modifications (5mC_5hmC or 5mCG_5hmCG). The workflow looks for bam files in bam directory and merges them, calls modifications using Rapid-CNS2 pipeline which runs MNPFlex preprocessing using mnpflex_script (mnp-flex_preprocessing-updated.sh) and generates an input data file for MNP-Flex tool. MNP-Flex API then generates a comprehensive molecular report based on input data file. the report includes coverage distribution, methylation value distribution, methylation classification (family, superfamily, class, subclass) and MGMT promoter methylation.
 
## Requirements:
- Nextflow (version 3.0.0 or later)
- Conda
- Docker or Singularity (optional, for containerized execution of tools)

## Input data:
- Raw ONT POD5 data (for basecalling) or pre-aligned BAM files i.e. bam_dir="/path to your bam files"
- Reference genome file (hg38 required) i.e. ref= "/path to reference file" 
- id="your sample name or any identifier"
- mnpflex_script="/mnp-flex_preprocessing-updated.sh"
- mnpflex_bed="/MNP-flex.bed"

* The input file for MNP-Flex API should be a tab separated (BED) file containing column names: "chr" "start" "end" "coverage" "methylation_percentage" "IlmnID"
#IlmnID -- Illumina InfiniumID for probe

- Duplicate IlmnID check in:
```bash
    awk '{print $6"\t"$1"\t"$2"\t"$3}' LBp-254-barcode04.MNPFlex.subset.bed | sort | uniq -d
```

## Output
- merged_bam="sample_MNPFlex.subset.bed"  ## output of Rapid-CNS2 which is used as input for MNPflex tool
- MNPFlex-report.pdf  ## report from MNPflex tool


## Installations

nextflow:
```bash
https://www.nextflow.io/docs/latest/install.html
```

java:
```bash
sudo apt install openjdk-17-jre-headless
```

download nextflow:
```bash
curl -s https://get.nextflow.io | bash
export CAPSULE_LOG=none
```

make nextflow executeable:
```bash
chmod +x nextflow
```

move nextflow to an executable path:
```bash
mkdir -p $HOME/.local/bin/
mv nextflow $HOME/.local/bin/
```

Temporarily add this directory ($HOME/.local/bin/) to PATH:
```bash
export PATH="$PATH:$HOME/.local/bin"
```

Add the directory to PATH permanently by adding the export command to your shell configuration file
```bash
~/.bashrc
```

check installation success:
```bash
nextflow info
nextflow.config
Installations Done
```
