SAMPLES = "sample1 sample2 sample3 sample4".split()
ROOT_FOLDER = "/path/to/root/dir"
REF_NAME = "reference_strain"
PREFIX = "snps_vs_"
REF = ROOT_DIR + "bwa_indicies/" + REF_NAME + ".fasta"
FASTQ_DIR = "fastq_files/"
RESULTS_DIR = "results/bwa/"
GENOME_DIR = ROOT_DIR + "genome_sequences/"

rule all:
  input: RESULTS_DIR + PREFIX + REF_NAME + ".bwa.40.fas"

rule map_reads :
  input: ref = REF , reads = FASTQ_DIR + "{sample}.{group}.fastq"
  output: temp(RESULTS_DIR + "{sample}_vs_" + REF_NAME + ".{group}.sai")
  shell: "/usr/local/bwa/bwa aln -t 8 {input.ref} {input.reads} > {output}"

rule sai_to_bam:
  input: REF, RESULTS_DIR + "{sample}_vs_" + REF_NAME + ".1.sai", RESULTS_DIR + "{sample}_vs_" + REF_NAME + ".2.sai", FASTQ_DIR + "{sample}.1.fastq", FASTQ_DIR + "{sample}.2.fastq"
  output: temp(RESULTS_DIR + "{sample}_vs_" + REF_NAME + ".bam")
  shell: "/usr/local/bwa/bwa sampe -r '@RG\\tID:{wild cards.sample}\\tSM:{wildcards.sample}' {input} | /usr/local/samtools/samtools view -buhS - > {output}"

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
  output: RESULTS_DIR + PREFIX + REF_NAME + ".bwa.vcf"
  run:
    inputs_with_prefix = ["-I " + bam_file for bam_file in expand(RESULTS_DIR + "{sample}_vs_" + REF_NAME + ".sorted.bam", sample=SAMPLES)]
    shell("java -Xmx30g -jar /usr/local/gatk2/GenomeAnalysisTK.jar -T UnifiedGenotyper -nt 12 -R  {input.ref} --sample_ploidy 2 --genotype_likelihoods_model BOTH -rf BadCigar {inputs_with_prefix} -o {output}")
