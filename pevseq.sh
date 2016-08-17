#!/bin/sh


# convert merged FASTQ file to FASTA with seqtk
echo "Converting FASTQ -> FASTA..."
i=1
while [ $i -le 59 ]; do
  EXPT=$(ls -al $HOME/seqdata/merged/ARRPA | grep -Po "\b"$i"_[ATGC-]*" | head -1)
  seqtk seq -a "$EXPT".assembled.fastq > "$EXPT".assembled.fasta
  echo "Done with "$EXPT""
  ((i++))
done

# BLAST each read against the input homologs with blastn
echo "BLASTing reads against input homologs..."
i=1
while [ $i -le 59 ]; do
  EXPT=$(find $HOME/seqdata/merged/ARRPA -maxdepth 1 | grep -Po "\b"$i"_[ATGC-]*" | head -1)

  blastn -query "$EXPT".assembled.fasta -db ATX1_Homologs_Pilot.fasta -max_hsps 1 -max_target_seqs -out "$EXPT".tsv -outfmt 6

  echo "Done with "$EXPT""
  ((i++))
done

# count the number of each homolog present in seq reads with grep | wc
echo "Tabulating homolog counts..."

HOMS=($(grep ">" ATX1_Homologs_Pilot.fasta | awk '{ gsub(">","",$1); print $1 }'))

i=1
while [ $i -le 59 ]; do
  EXPT=$(find $HOME/seqdata/merged/ARRPA -maxdepth 1 | grep -Po "\b"$i"_[ATGC-]*" | head -1)

  for i in $HOMS; do
    echo "$i: $(grep $i "$EXPT".tsv | wc -l) reads"

  echo "Done with "$EXPT""
  ((i++))
done

# output results to R-friendly file(s)
