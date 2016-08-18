#!/bin/sh

##
# Run from directory containing merged reads, aka $IN
# Ex (Scarcity): /home/GLBRCORG/dtdoering/seqdata/merged/ARRPA
##

IN=$1 # input data directory (assembled reads)
HOMOLOGSFILE=$2 # FASTA filepath with input homologs/variants
OUT=$3 # destination directory (assembled FASTA, BLAST results, )

echo "Working directory: $IN"
echo "Input homologs: $HOMOLOGSFILE"
echo "Output directory: $OUT"

# create array of homologs for later comparison
# HOMS=($(grep ">" $HOMOLOGSFILE | awk '{ gsub(">","",$1); print $1 }'))

HOMS=$(grep ">" ./ATX1_Homologs_Pilot.fasta | cut -f2- -d'>')

i=1
while [ $i -le 59 ]; do
  echo "Starting experiment $i"

  EXPT=$(ls -al $IN/assembled | grep -Po "\b"$i"_[ATGC-]*" | head -1)

  # merged FASTQ -> FASTA with seqtk
  seqtk seq -a $IN/assembled/"$EXPT".assembled.fastq > $IN/assembled/"$EXPT".assembled.fasta

  # create BLAST db if needed
  if [ ! -f $(dirname $HOMOLOGSFILE)/blastdbs/$(basename $HOMOLOGSFILE).nhr ]; then
    makeblastdb -in $HOMOLOGSFILE -dbtype 'nucl' -out $(dirname $HOMOLOGSFILE)/blastdbs/$(basename $HOMOLOGSFILE)
  fi

  # BLAST each read against the input homologs
  blastn -query $IN/assembled/"$EXPT".assembled.fasta -db $(dirname $HOMOLOGSFILE)/blastdbs/$(basename $HOMOLOGSFILE) -max_target_seqs 1 -out $OUT/blastresults/"$EXPT".blastout.tsv -outfmt 6

  # count the number of each homolog
  for j in $HOMS; do
    READS=$(grep $j $OUT/blastresults/"$EXPT".blastout.tsv | wc -l)
    TOTAL=$(wc -l < $OUT/blastresults/"$EXPT".blastout.tsv)

    # Output like "Scer: X / TOT reads (Y.YYY %)"
    echo "$j: "$READS" / "$TOTAL" reads ($(echo "scale=3;100*$READS/$TOTAL" | bc) %)" 2>&1 | tee -a $OUT/"$EXPT"_counts.txt
  done

  echo "Done with "$EXPT""
  ((i++))
done
