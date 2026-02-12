
#!/bin/bash
set -euo pipefail
# Inputs
bam_dir="/Directory containing your BAM files" 
ref="/reference/GRCh38.p14.genome.fa"
id="NB12"
modkit_threads=8
mnpflex_script="/mnp-flex_preprocessing-updated.sh"
mnpflex_bed="/MNP-flex.bed"
# Output paths
merged_bam="merged/${id}.merged.bam"
mods_out="results/mods"
mnpflex_out="results/mnpflex"
# Find all BAMs in the folder
bam_files=($(find "$bam_dir" -name "*.bam"))
if [[ ${#bam_files[@]} -eq 0 ]]; then
    echo "No BAM files found!"
    exit 1
fi
echo "Found ${#bam_files[@]} BAM files for ID $id"
# Merge BAMs
echo "Merging BAM files..."
mkdir -p merged "$mods_out"
samtools merge -@ "$modkit_threads" "$merged_bam" "${bam_files[@]}"
# Index merged BAM
echo "Indexing merged BAM..."
samtools index -@ "$modkit_threads" "$merged_bam"
# Run modkit pileup
echo "Running modkit pileup..."
mkdir -p "$mods_out"
modkit pileup \
    "$merged_bam" \
    "$mods_out/${id}.mods.bedmethyl" \
    --ref "$ref" \
    --threads "$modkit_threads"
echo "Done: ${mods_out}/${id}.mods.bedmethyl"
# Run MNPFlex preprocessing
mkdir -p "$mnpflex_out"
echo "Starting MNPFlex preprocessing..."
bash "$mnpflex_script" \
    "$mods_out/${id}.mods.bedmethyl" \
    "$mnpflex_bed" \
    "$mnpflex_out" \
    "${id}"
echo "Finished MNPFlex preprocessing."
