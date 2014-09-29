#! /bin/bash

# quick script to start large spades assembly for a bunch of genomes

cd ./US957

python ../../SPAdes/bin/spades.py -1 US957-2_GCTACGCT-CTAAGCCT_L001_R1_001.fastq.gz -2 US957-2_GCTACGCT-CTAAGCCT_L001_R2_001.fastq.gz -o ./assembly

cd ../US968

mkdir assembly

python ../../SPAdes/bin/spades.py -1 US968-2_CGAGGCTG-TAGATCGC_L001_R1_001.fastq.gz -2 US968-2_CGAGGCTG-TAGATCGC_L001_R2_001.fastq.gz -o ./assembly

cd ../US970

mkdir assembly

python ../../SPAdes/bin/spades.py -1 US970-2_CGAGGCTG-CTCTCTAT_L001_R1_001.fastq.gz -2 US970-2_CGAGGCTG-CTCTCTAT_L001_R2_001.fastq.gz -o ./assembly

cd ../US972

mkdir assembly

python ../../SPAdes/bin/spades.py -1 US972-3_CGAGGCTG-TATCCTCT_L001_R1_001.fastq.gz -2 US972-3_CGAGGCTG-TATCCTCT_L001_R2_001.fastq.gz -o ./assembly

cd ../US975

mkdir assembly

python ../../SPAdes/bin/spades.py -1 US975-1_CGAGGCTG-AGAGTAGA_L001_R1_001.fastq.gz -2 US975-1_CGAGGCTG-AGAGTAGA_L001_R2_001.fastq.gz -o ./assembly

cd ../US977

mkdir assembly

python ../../SPAdes/bin/spades.py -1 US977-2_CGAGGCTG-GTAAGGAG_L001_R1_001.fastq.gz -2 US977-2_CGAGGCTG-GTAAGGAG_L001_R2_001.fastq.gz -o ./assembly

cd ../US980

mkdir assembly

python ../../SPAdes/bin/spades.py -1 US980-1_CGAGGCTG-ACTGCATA_L001_R1_001.fastq.gz -2 US980-1_CGAGGCTG-ACTGCATA_L001_R2_001.fastq.gz -o ./assembly

cd ../US984

mkdir assembly

python ../../SPAdes/bin/spades.py -1 US984-1_CGAGGCTG-AAGGAGTA_L001_R1_001.fastq.gz -2 US984-1_CGAGGCTG-AAGGAGTA_L001_R2_001.fastq.gz -o ./assembly

cd ../US987

mkdir assembly

python ../../SPAdes/bin/spades.py -1 US987-2_CGAGGCTG-CTAAGCCT_L001_R1_001.fastq.gz -2 US987-2_CGAGGCTG-CTAAGCCT_L001_R2_001.fastq.gz -o ./assembly

cd ../US988


mkdir assembly

python ../../SPAdes/bin/spades.py -1 US988-2_AAGAGGCA-TAGATCGC_L001_R1_001.fastq.gz -2 US988-2_AAGAGGCA-TAGATCGC_L001_R2_001.fastq.gz -o ./assembly

cd ../US990

mkdir assembly

python ../../SPAdes/bin/spades.py -1 US990-2_AAGAGGCA-CTCTCTAT_L001_R1_001.fastq.gz -2 US990-2_AAGAGGCA-CTCTCTAT_L001_R2_001.fastq.gz -o ./assembly

cd ../US1018

mkdir assembly

python ../../SPAdes/bin/spades.py -1 US1018-1_TCCTGAGC-TATCCTCT_L001_R1_001.fastq.gz -2 US1018-1_TCCTGAGC-TATCCTCT_L001_R2_001.fastq.gz -o ./assembly

cd ../US1020

mkdir assembly

python ../../SPAdes/bin/spades.py -1 US1020-1_TAGGCATG-GTAAGGAG_L001_R1_001.fastq.gz -2 US1020-1_TAGGCATG-GTAAGGAG_L001_R2_001.fastq.gz -o ./assembly

# end
