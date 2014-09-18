import glob
import re
import shutil
import os
os.putenv('PATH', '/Applications/Mauve.app/Contents/MacOS:' + os.getenv('PATH'))
SAMPLES = "sample1 sample2 sample3 sample4".split()
ROOT_FOLDER = "/path/to/root/dir"
REF_NAME = "reference_strain"
REF = os.path.join(ROOT_FOLDER, "fasta_genomes", REF_NAME + ".fasta")


rule all:
  input: expand("velvet/{sample}/contigs.reordered.fasta", sample=SAMPLES)


rule reorder_contigs:
  input: ref = REF, unordered_contig = "velvet/{sample}/contigs.fa"
  output: "velvet/{sample}/contigs.reordered.fasta"
  run:
    shell("java -Xmx500m -cp /Applications/Mauve.app/Contents/Resources/Java/Mauve.jar org.gel.mauve.contigs.ContigOrderer -output /tmp/MCM/{wildcards.sample} -ref {input.ref} -draft {input.unordered_contig}")
    alignments = glob.glob("/tmp/MCM/" + wildcards.sample + "/alignment*")
    alignment_numbers = [int(re.search('alignment(\d+)', alignment).group(1)) for alignment in alignments]
    alignment_numbers.sort()
    shutil.copyfile("/tmp/MCM/" + wildcards.sample + "/alignment%d/contigs.fa.fas" % alignment_numbers[-1], "velvet/" + wildcards.sample + "/contigs.reordered.fasta" )
