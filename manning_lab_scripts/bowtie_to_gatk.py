SAMPLES = "sample1 sample2 sample3 sample4".split()
PAIRED_END_SAMPLES = "sample1 sample2".split()
MATE_PAIRED_SAMPLES = "sample3 sample4".split()
ROOT_DIR = "/path/to/root/dir"
REF_NAME = "ref_strain"
PREFIX = "snps_vs_"
REF = ROOT_DIR + "bowtie2_indicies/" + REF_NAME + ".fasta"
FASTQ_DIR = "fastq_files/"
RESULTS_DIR = "results/bowtie2/"
GENOME_DIR = ROOT_DIR + "genome_sequences/"


rule all:
  input: RESULTS_DIR + PREFIX + REF_NAME + ".bowtie2.40.fas"

rule map_reads:
  input: ref = REF , forward_read = FASTQ_DIR + "{sample}.1.fastq", reverse_read = FASTQ_DIR + "{sample}.2.fastq"
  output: temp(RESULTS_DIR + "{sample}_vs_" + REF_NAME + ".sam")
  run: 
    if wildcards.sample in PAIRED_END_SAMPLES:
     shell("/usr/local/bowtie2/bowtie2 -p 12 --rg-id 1 --rg \"SM:{wildcards.sample}\" --fr --minins 200 --maxins 1100 -x {input.ref} -1 {input.forward_read} -2 {input.reverse_read} -S {output}")
    elif wildcards.sample in MATE_PAIRED_SAMPLES:
     shell("/usr/local/bowtie2/bowtie2 -p 12 --rg-id 1 --rg \"SM:{wildcards.sample}\" --rf --minins 2000 --maxins 5000 -x {input.ref} -1 {input.forward_read} -2 {input.reverse_read} -S {output}")

rule convert_to_bam:
  input: temp(RESULTS_DIR + "{sample}_vs_" + REF_NAME + ".sam")
  output: temp(RESULTS_DIR + "{sample}_vs_" + REF_NAME + ".bam")
  shell: "/usr/local/samtools/samtools view -buhS -o {output} {input}"

rule sort_bam:
  input: RESULTS_DIR + "{sample}_vs_" + REF_NAME + ".bam"
  output: protected(RESULTS_DIR + "{sample}_vs_" + REF_NAME + ".sorted.bam")
  run:
    shell("/usr/local/samtools/samtools sort {input} " + RESULTS_DIR + "{wildcards.sample}_vs_%s.sorted" % REF_NAME)

rule index_bam:
  input: RESULTS_DIR + "{sample}_vs_" + REF_NAME + ".sorted.bam"
  output: protected(RESULTS_DIR + "{sample}_vs_" + REF_NAME + ".sorted.bam.bai")
  shell: "/usr/local/samtools/samtools index {input}"

rule call_snps:
  input: ref = REF, bam = expand(RESULTS_DIR + "{sample}_vs_" + REF_NAME + ".sorted.bam", sample=SAMPLES), bam_indicies = expand(RESULTS_DIR + "{sample}_vs_" + REF_NAME + ".sorted.bam.bai", sample=SAMPLES)
  output: RESULTS_DIR + PREFIX + REF_NAME + ".bowtie2.vcf"
  run:
    inputs_with_prefix = ["-I " + bam_file for bam_file in expand(RESULTS_DIR + "{sample}_vs_" + REF_NAME + ".sorted.bam", sample=SAMPLES)]
    shell("java -Xmx30g -jar /usr/local/gatk2/GenomeAnalysisTK.jar -T UnifiedGenotyper -nt 12 -R  {input.ref} --sample_ploidy 2 --genotype_likelihoods_model BOTH -rf BadCigar {inputs_with_prefix} -o {output}")
