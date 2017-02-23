# PEVSeq: Script(s) to analyze Paired-End Variant Sequencing 

`pevseq-blast.sh` is a standalone script that takes forward and reverse `.fastq` files of amplicon sequencing data and does the following:

1. Merge forward and reverse reads with [PEAR](https://github.com/xflouris/PEAR).
2. Convert `.fastq` of merged reads to `.fasta` with [seqtk](https://github.com/lh3/seqtk).
3. Call variants by BLASTing to local database with `tblastn`, creating a TSV of hits.
4. Tally up the hits for each variant with a bash loop and ouput the number of reads per variant relative to the total number of reads for that timepoint/sample.
