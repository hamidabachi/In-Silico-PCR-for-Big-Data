#!/bin/bash

# Set the paths
input_dir="/home/hamid/analysis/pcr/in/"  # Replace with the path to your genome files
output_dir="/home/hamid/analysis/pcr/out/" # Replace with the desired output directory

# Specify primer sequences
forward_primer="CGAACTCGACCAGGTTCTCG"
reverse_primer="GGTCTCACGATCGGATCC"

# Create empty result files
> "$output_dir/results.txt"
> "$output_dir/all_amplicons.fasta"

# Loop through genome files
for genome_file in "$input_dir"/*.fasta; do
    # Extract genome name from the file path
    genome_name=$(basename "$genome_file" .fasta)

    # Run in silico PCR
    /usr/bin/perl /home/hamid/analysis/pcr/in/in_silico_PCR.pl -s "$genome_file" -a "$forward_primer" -b "$reverse_primer" > "$output_dir/${genome_name}_results.txt" 2> "$output_dir/${genome_name}_amplicons.fasta"

    # Remove newline after > in results.txt
    sed -i '/^>/s/$//' "$output_dir/${genome_name}_results.txt"

    # Add the input file name as a single header in amplicons.fasta
    sed -i "1s/.*/>${genome_name}/" "$output_dir/${genome_name}_amplicons.fasta"

    # Append results to the consolidated results file
    cat "$output_dir/${genome_name}_results.txt" >> "$output_dir/results.txt"

    # Append amplicons to the consolidated amplicons file
    cat "$output_dir/${genome_name}_amplicons.fasta" >> "$output_dir/all_amplicons.fasta"

    # Optionally, you can include additional processing or analysis steps here
done
