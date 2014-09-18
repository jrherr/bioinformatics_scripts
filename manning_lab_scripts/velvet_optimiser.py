SAMPLES = "sample1 sample2 sample3 sample4".split()
ROOT_FOLDER = "/path/to/root/dir"
FASTQ_DIR = "fastq_files"
RESULTS_DIR = "results/velvet"
THREADS = 12
START_KMER = 61
END_KMER = 99

rule all:
  input: expand(RESULTS_DIR + "/{sample}/contigs-large.fas", sample=SAMPLES)

rule shuffle_reads:
  input: FASTQ_DIR + "/{sample}.1.trimmed.cor.fastq", FASTQ_DIR + "/{sample}.2.trimmed.cor.fastq"
  output: protected(FASTQ_DIR + "/{sample}.shuffled.fastq")
  shell: "/usr/local/velvet/shuffleSequences_fastq.pl {input} {output}"

rule velvet_optimiser:
  input: FASTQ_DIR + "/{sample}.shuffled.fastq"
  output: protected(RESULTS_DIR + "/{sample}/contigs.fa")
  run:
    shell("perl /usr/local/velvet_optimiser/VelvetOptimiser.pl -s " + str(START_KMER) + " -e " + str(END_KMER) + " -f '-shortPaired -fastq {input}' -t " + str(THREADS) +" -d " + RESULTS_DIR + "/{wildcards.sample}_temp; rmdir " + RESULTS_DIR + "/{wildcards.sample}; mv " + RESULTS_DIR + "/{wildcards.sample}_temp " + RESULTS_DIR + "/{wildcards.sample}")

rule slim_contigs:
  input: RESULTS_DIR + "/{sample}/contigs.fa"
  output: RESULTS_DIR + "/{sample}/contigs-large.fas"
  run:
    shell("ruby /Users/josh/Documents/Ruby/lib/genome/contig_slimmer.rb " + input[0])
    shell("ruby /Users/josh/Documents/Ruby/lib/genome/n50.rb " + output[0])
