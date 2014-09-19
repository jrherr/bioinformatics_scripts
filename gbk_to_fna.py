# script to use BioPython to parse taxonomy annotations for genbank file

from Bio import SeqIO

gbk_filename = ".gbk"
faa_filename = ".fna"

input_handle  = open(gbk_filename, "r")
output_handle = open(faa_filename, "w")

#Short version:
#SeqIO.write(SeqIO.parse(input_handle, "genbank"), output_handle, "fasta")

#Long version, allows full control of fasta output
for seq_record in SeqIO.parse(input_handle, "genbank") :
    print "Parsing GenBank record %s" % seq_record.id
    output_handle.write(">%s %s\n%s\n" % (
           seq_record.id,
           seq_record.description,
           seq_record.annotations['taxonomy']
           seq_record.seq.tostring()))
           '; '.join(seq_record.annotations['taxonomy'])

output_handle.close()
input_handle.close()
print "Completed"
