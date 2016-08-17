#!/usr/bin/python

import sys
import os
import Bio
from Bio import SeqIO
from StringIO import StringIO
import Levenshtein as lev

homologfile = "example.fasta" # change to accurate
seqfile = "seqdata.fastq" # change to accurate

homologs = {}
with open(homologfile, 'rU') as f:
    for record in SeqIO.parse(f, "fasta"):
        homologs[record.id] = record.Seq

# Use biopython generators, might not be able to build a huge 2nd-order list and lookup smallest distance by row

reads = []
with open(seqfile, 'rU') as f:
    for seq in SeqIO.parse(f, "fastq")
        seqdata

# for each read, find its Lev dist to each homolog and add a tick to the count for whichever homolog has the lowest distance (should be zero in vast majority of cases)

# for instances where non-zero distances are found, note them all but add a tick for the shortest one
# if there are ties, output
distances = []
for i in seqdata:
    distances[i] = []
    for j in seqdata:
        j.seq()
        lev.distance(i,j)


# Use "SeqIO-to_dict" function only for variants that don't map directly to an input homolog. This function adds the read to a SeqRecord dictionary IN MEMORY, which should be minimized to allow fast execution of the script.

tempdistout = []
for i in dists:
    if dists[i] == 0:
        print i
        tempdistout.append(i)
    else:
        print "No exact matches found."
if len(tempdistout) == 0: # no matches
    # append output with read


records = (rec for rec in SeqIO.parse(adsfas) if lev.distance(rec, homolog) > 0
