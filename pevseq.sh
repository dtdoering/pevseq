#!/bin/sh

IN=$1 # input data directory (merged reads)
OUT=$2 # destination directory (assembled FASTA, BLAST results, )

# create array of homologs for later comparison
HOMS=($(grep ">" ATX1_Homologs_Pilot.fasta | awk '{ gsub(">","",$1); print $1 }'))

i=1
while [ $i -le 59 ]; do
  EXPT=$(ls -al $HOME/seqdata/merged/ARRPA | grep -Po "\b"$i"_[ATGC-]*" | head -1)

  # merged FASTQ -> FASTA with seqtk
  seqtk seq -a "$EXPT".assembled.fastq > "$EXPT".assembled.fasta

  # BLAST each read against the input homologs
  blastn -query "$EXPT".assembled.fasta -db ATX1_Homologs_Pilot.fasta -max_hsps 1 -max_target_seqs -out "$EXPT".tsv -outfmt 6

  # count the number of each homolog
  for j in $HOMS; do
    READS=$(grep $j "$EXPT".tsv | wc -l)
    TOTAL=$(wc -l < "$EXPT".tsv)
    # Output like "Scer: X / TOT reads (Y.YYY %)"
    echo "$j: "$READS" / "$TOTAL" reads ($(echo "scale=3;100*$READS/$TOTAL" | bc) %)" 2>&1 | tee -a "$EXPT"_counts.txt
  done

  echo "Done with "$EXPT""
  ((i++))
done

# output results to R-friendly file(s)
