'''
Generate a CSV file with OTU information, abundance, and rank 
USAGE: python otu_abundance.py /path/to/final_OTU_map_file.txt
contact: joshua.r.herr@gmail.com
'''

from collections import Counter
import sys

OTU_file = sys.argv[1]

# collect OTU information

OTUs = {}

with open(OTU_file, 'r') as INfile:
    for line in INfile:
        line = line.strip('\n').split('\t')
        myOTU = line[0]
        OTUs[myOTU] = []
        for item in line[1:]:
            OTUs[myOTU].append(item)

# raw adundance

RawAbundDic = {}

for sample in OTUs.keys():
    tally = Counter()
    for elem in [x.split('_')[0] for x in OTUs[sample]]:
        tally[elem] += 1
    RawAbundDic[sample] = dict(tally)

# proportional abundance

Totals = {}

for otu in RawAbundDic.keys():
    for sample in RawAbundDic[otu]:
        try:
            Totals[sample] += RawAbundDic[otu][sample]
        except KeyError:
            Totals[sample] = 0
            Totals[sample] += RawAbundDic[otu][sample]

# overall rank of abundance

Rank = {}

for otu in RawAbundDic.keys():
    for sample in RawAbundDic[otu]:
        PropAbund = float(RawAbundDic[otu][sample])/float(Totals[sample])
        try:
            Rank[sample][otu] = {'rank': 0, 'abund': PropAbund}
        except KeyError:
            Rank[sample] = {}
            Rank[sample][otu] = {'rank': 0, 'abund': PropAbund}

for sample in Rank:
    Abunds = [(x, Rank[sample][x]['abund']) for x in Rank[sample].keys()]
    SortedAbunds = sorted(Abunds, key=lambda abund: abund[1])
    for i in SortedAbunds:
        myRank = len(Abunds) - SortedAbunds.index(i)
        Rank[sample][i[0]]['rank'] = myRank

with open("OTU_Rank_Abundance.csv", 'w') as outfile:
    outfile.write("OTU, Sample, Abundance, Proportional Abundance, Rank\n")
    for sample in Rank.keys():
        for otu in Rank[sample]:
            outfile.write("%s, %s, %s, %s, %s\n" % (otu, sample, str(RawAbundDic[otu][sample]), str(Rank[sample][otu]['abund']), str(Rank[sample][otu]['rank'])))
