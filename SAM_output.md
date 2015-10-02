Output SAM mapped reads

# Mapped pairs (fwd. and rev. both mapped)
samtools view -f 2 mapping.sorted.bam | cut -f1 | sort | uniq

# Unmapped pairs (fwd. and rev. both unmapped)
samtools view -F 2 mapping.sorted.bam | cut -f1 | sort | uniq

# Mapped fwd. (rev. is unmapped)
samtools view -F 4 -f 64 mapping.sorted.bam | cut -f1 | sort | uniq

# Mapped rev. (fwd. is unmapped)
samtools view -F 4 -f 128 mapping.sorted.bam | cut -f1 | sort | uniq

# Unmapped fwd. (rev. is mapped)
samtools view -f 68 mapping.sorted.bam | cut -f1 | sort | uniq

# Unmapped rev. (fwd. is mapped)
samtools view -f 72 mapping.sorted.bam | cut -f1 | sort | uniq

# And if you just want counts of the above, then add | wc -l to the end of any of the above commands.
