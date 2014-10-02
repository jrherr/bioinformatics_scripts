#!/usr/bin/env python
#
# Submit multiple Prokka jobs to SLURM (input = contig files; proteins)
#
# Authors - Jane Hawkey (j.hawkey@student.unimelb.edu.au)
#
# Dependencies:
#         loads prokka/1.7.1
#
# Example command on merri:
'''
module load python-gcc/2.7.5
python /vlsci/VR0082/shared/code/holtlab/runProkka_SLURM.py -o outdir -p proteins.aa -g Genus -s species -d dir -e _contigs.fasta *_contigs.fasta
'''
#
# Last modified - Oct 15, 2013
# Changes:
#         15/10/13 - Removed requirement for proteins database to be specified (Kat)
import string, re
import os, sys
from optparse import OptionParser


def main():

        usage = "usage: %prog [options]"
        parser = OptionParser(usage=usage)

        parser.add_option("-o", "--outdir", action="store", dest="outdir", help="directory for output", default="")
        parser.add_option("-p", "--proteins", action="store", dest="proteins", help="protein file for prokka to search through", default="")
        parser.add_option("-g", "--genus", action="store", dest="genus", help="genus", default="")
        parser.add_option("-s", "--species", action="store", dest="species", help="species", default="")
        parser.add_option("-t", "--walltime", action="store", dest="walltime", help="wall time (default 0-01:00:00 = 1h)", default="0-01:00:00")
        parser.add_option("-m", "--memory", action="store", dest="mem", help="memory in mb (default 4096)", default="4096")
        parser.add_option("-d", "--rundir", action="store", dest="rundir", help="directory to run in", default="")
        parser.add_option("-e", "--extension", action="store", dest="extension", help="extension for contigs file (default _contigs.fasta)", default="_contigs.fasta")

        return parser.parse_args()


if __name__ == "__main__":

        (options, args) = main()

        if options.outdir[-1] != "/":
                options.outdir += "/"
        if options.genus=="":
                DoError("No genus provided")
        if options.species=="":
                DoError("No species provided")
        if options.proteins=="":
                print "No protein list provided, using default database"
        if options.outdir=="":
                DoError("No output directory provided")
        if options.rundir=="":
                options.rundir = os.getcwd()

        for fasta in args:
                baseFile = os.path.basename(fasta)
                prefix = re.sub(options.extension, "", baseFile)
                cmd = "#!/bin/bash\n#SBATCH --job-name=prokka" + prefix
                cmd += "\n#SBATCH --time=" + options.walltime
                cmd += "\n#SBATCH --mem-per-cpu=" + options.mem
                cmd += "\ncd " + options.rundir

                #load modules
                cmd += "\nmodule load prokka/1.7.1\n"
                cmd += "prokka --prefix " + prefix 
                if options.proteins != "":
                        cmd += " --proteins " + options.proteins 
                cmd += " --outdir " + options.outdir + prefix + " --addgenes --genus " + options.genus + " --species " + options.species + " --gcode 11 " + fasta
                os.system('echo "' + cmd + '" | sbatch')
                print cmd