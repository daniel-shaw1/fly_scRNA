import sys
import re

input_gtf = "cellranger_fly_clean.gtf"     # replace with your GTF path
output_gtf = "cellranger_fly_dedup.gtf"

gene_id_counts = {}
gene_id_map = {}

def replace_gene_id(line, new_id):
    # Replace gene_id "...";
    line = re.sub(r'gene_id "([^"]+)"', f'gene_id "{new_id}"', line)
    # Also replace gene "..." if present
    line = re.sub(r'gene "([^"]+)"', f'gene "{new_id}"', line)
    return line

with open(input_gtf, 'r') as infile, open(output_gtf, 'w') as outfile:
    for line in infile:
        if line.startswith('#'):
            outfile.write(line)
            continue
        # Extract gene_id
        m = re.search(r'gene_id "([^"]+)"', line)
        if not m:
            outfile.write(line)
            continue
        gene_id = m.group(1)
        if gene_id not in gene_id_counts:
            gene_id_counts[gene_id] = 0
            gene_id_map[gene_id] = gene_id
            new_id = gene_id
        else:
            gene_id_counts[gene_id] += 1
            new_id = f"{gene_id}.{gene_id_counts[gene_id]}"
            gene_id_map[gene_id] = new_id
        # Replace gene_id and gene attribute with new unique ID
        new_line = replace_gene_id(line, new_id)
        outfile.write(new_line)
