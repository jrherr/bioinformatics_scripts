#! bin/bash

for file in $(<list.txt)
do
  pandaseq -f ${file}_forward.fastq -r ${file}_reverse.fastq -A pear -w assembled_reads/${file}.fasta -g assembled_reads/${file}.log
done
