#!/usr/bin/env python
#
# Submits RAxML jobs to SLURM
#
# Authors - Danielle Ingle, Kat Holt
#
# Dependencies:
#         none
#
# Example command on merri:
'''
module load python-gcc/2.7.5
python /vlsci/VR0082/shared/code/holtlab/runRax_SLURM.py -f file.fasta -o output
'''
#
# Last modified - Oct 24, 2013

import string, re
import random
import os, sys, subprocess
from optparse import OptionParser


def main():

    usage = "usage: %prog [options]"
    parser = OptionParser(usage=usage)

    # required sbatch options
    parser.add_option("-d", "--rundir", action="store", dest="rundir", help="directory to run in", default="")
    parser.add_option("-M", "--memory", action="store", dest="memory", help="memory for raxml jobs (24576)", default="24576")
    parser.add_option("-t", "--walltime", action="store", dest="walltime", help="walltime for raxml jobs (set to 0 to switch off, default 5-12:0, ie 5.5. days)", default="5-12:0")


    # command-specific options
    parser.add_option("-a", "--aln", action="store", dest="aln", help="input alignment sequence (phy)", default="seq.phy")
    parser.add_option("-N", "--N", action="store", dest="N", help="number of raxml bootstraps (100)", default="100")
    parser.add_option("-n", "--numrax", action="store", dest="numrax", help="number of raxml jobs (10)", default="10")
    parser.add_option("-T", "--threads", action="store", dest="threads", help="number of threads per raxml job (8)", default="8")
    parser.add_option("-p", "--prefix", action="store", dest="prefix", help="prefix to add to output files (default none)", default="")

    return parser.parse_args()

if __name__ == "__main__":

    (options, args) = main()

    if options.walltime=="":
        options.walltime = "5-12:00"
    if options.memory=="":
        options.memory = "24576"
    if options.rundir=="":
        options.rundir = os.getcwd()
    if options.N=="":
        options.N = "100"
    if options.numrax=="":
        options.numrax = "10"
    if options.threads=="":
        options.threads = "8"

    # note everything given on command line outside the above specified options is stored in 'args' list
    for rep in range(0,int(options.numrax)):
        seed = random.randint(10000,1000000)
        if seed % 2 == 0:
            seed += 1
        p = random.randint(10000,1000000)
        if p % 2 == 0:
            p += 1

        # prepare job script
        jobscript = options.prefix + "_rax_" + str(rep) + ".sh"
        o = file(jobscript, "w")
        print "\nRunning RAxML 7.7.2 (PTHREADS) on " + options.aln + ", using job script: " + jobscript
        rax_pre = options.prefix + "_" + str(rep)
        if os.path.exists("RAxML_info."+rax_pre):
            rax_pre = options.prefix + "_" + str(rep) + "_" + str(seed) # make sure output is unique
        o.write("#!/bin/bash")
        o.write("\n#SBATCH -p main")
        o.write("\n#SBATCH --job-name=rax" + options.prefix + str(rep))
        o.write("\n#SBATCH --time=" + options.walltime)
        o.write("\n#SBATCH --mem=" + options.memory)
        o.write("\n#SBATCH --ntasks=" + options.threads)
        o.write("\n#SBATCH --nodes=1")
        o.write("\n#SBATCH --exclusive")
        o.write("\ncd " + os.getcwd())
        # load modules
        o.write("\nmodule load raxml-intel/7.7.2\n")

        #o.write("raxmlHPC -s " + aln)
        # commands
        o.write("raxmlHPC-PTHREADS -T " + options.threads + " -s " + options.aln)
        o.write(" -n " + rax_pre + " -f a -m GTRGAMMA -x " + str(seed) )
        o.write(" -N " + options.N + " -p " + str(p) + "\n")
        o.close()
        os.system('sbatch ' + jobscript)
        # print and run command
        print "...output will be in RAxML_" + rax_pre