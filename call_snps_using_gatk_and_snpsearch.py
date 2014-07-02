import os
SAMPLES = "sample1 sample2 sample3 sample4".split()
ROOT_FOLDER = "/path/to/root/dir"
REF_NAME = "reference_strain"
REF = os.path.join(ROOT_FOLDER, "fasta_genomes", REF_NAME + ".fasta")
DATA_DIR = os.path.join(ROOT_FOLDER, "bam_files")
RESULTS_DIR = os.path.join(DATA_DIR, "results")


rule all:
  input: os.path.join(RESULTS_DIR,"snps_vs_" + REF_NAME + ".40.fas")

rule call_snps:
  input: ref = REF, bam = expand(os.path.join(DATA_DIR, "{sample}.sorted.bam"), sample=SAMPLES)
  output: os.path.join(RESULTS_DIR, "snps_vs_" + REF_NAME + ".vcf")
  run:
    inputs_with_prefix = ["-I " + bam_file for bam_file in expand(os.path.join(DATA_DIR, "{sample}.sorted.bam"), sample=SAMPLES)]
    shell("java -Xmx30g -jar /usr/local/gatk2/GenomeAnalysisTK.jar -T UnifiedGenotyper -nt 12 -R  {input.ref} --sample_ploidy 2 --genotype_likelihoods_model BOTH -rf BadCigar {inputs_with_prefix} -o {output}")

rule create_snp_search_db:
  input: os.path.join(RESULTS_DIR, "snps_vs_" + REF_NAME + ".vcf")
  output: os.path.join(RESULTS_DIR,"snps_vs_" + REF_NAME + ".sqlite")
  run:
    shell("snp-search  -C -d " + os.path.join(ROOT_FOLDER, "genbank_genomes/MSSA476.gbk") + " -v {input} -n {output}")

rule create_fasta_file:
  input: os.path.join(RESULTS_DIR,"snps_vs_" + REF_NAME + ".sqlite")
  output: os.path.join(RESULTS_DIR,"snps_vs_" + REF_NAME + ".40.fas")
  shell: "snp-search -Q -R -a phage,transp,ribosomal,spa -n {input} -o  {output} -g 40 -I MRSA252 -r"
