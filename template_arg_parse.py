#!/usr/bin/env python
#
# Short description of the script
#
# Note this script submits jobs to SLURM
#
# Authors - name (email)
#
# Dependencies:
#         bowtie2, samtools 0.1.18
#
# Last modified - Oct 10, 2013
# Changes:
#         10/10/13 - added X Y Z features (name)
#         1/8/13 - fixed bug X (name)
#
# Example command on merri:
'''
module load python-gcc/2.7.5
module load bowtie2-intel/2.1.0
module load samtools-intel/0.1.18
python /vlsci/VR0082/shared/code/holtlab/script.py -f file.fasta -o output
'''


from argparse import (ArgumentParser, FileType)
import os, sys, re, collections, operator

def parse_args():
        "Parse the input arguments, use '-h' for help"
        parser = ArgumentParser(description='My fantastic script')
        parser.add_argument(
                '--input_reads', nargs='+', type=str, required=False,
                help='Input multiple arguments')
        parser.add_argument(
                '--input_pair', nargs=2, type=str, required=False,
                help='Input exactly two arguments')
        parser.add_argument(
                '--verbose', action="store_true", required=False, help='Switch on some setting')
        parser.add_argument( '--number', type=int, default=1, help='Integer argument') 
        return parser.parse_args() 

# other functions

# main function
def main():
    args = parse_args()


# call main function
if __name__ == '__main__':
        main()