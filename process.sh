#!/bin/sh



# usage:
# process.sh DESTDIR
gunzip *.fastq.gz # unzip files

# $1 = DEST=$HOME/seqdata/unzipped/ARRPA

# extract with gzip
for f in ./*.fastq.gz; do
  STEM=$(basename "${f}" .gz)
  gunzip -c "${f}" > $1/"${STEM}"
done

# run PEAR for all cognate pairs of files
end=$(find $HOME/seqdata/unzipped/ARRPA | grep 'R1.*.fastq$' | wc -l) # however many experiments there are

i=1
while [ $i -le 59 ]; do
  EXPT=$(find $HOME/seqdata/unzipped/ARRPA -maxdepth 1 | grep -Po "\b"$i"_[ATGC-]*" | head -1)
  FW=""$EXPT"_L001_R1_001.fastq"
  RV=""$EXPT"_L001_R2_001.fastq"
  ##NEED TO TELL IT TO PUT EVERYTHING IN ANOTHER DIR
  echo "merging files..."
  echo "pear -f "$FW" -r "$RV" -o "$EXPT" > "$EXPT"-summary.txt"
  echo "Forward reads: "$FW""
  echo "Reverse reads: "$RV""
  pear -f $FW -r $RV -o $HOME/seqdata/merged/ARRPA2/$EXPT > $HOME/seqdata/merged/ARRPA2/summary/"$EXPT-summary.txt"
  echo "Done with "$EXPT""
  ((i++))
done


for i in $(bash -c "echo {1..${end}}"); do
  # FW=$(find . -maxdepth 1 | grep "\b"$i".*R1.*.fastq")
  # RV=$(find . -maxdepth 1 | grep "\b"$i".*R2.*.fastq")
  EXPT=$(find -maxdepth 1 | grep -Po ""$i"_[ATGC-]*" | head -1)
  FW=""$EXPT"_L001_R1_001.fastq"
  RV=""$EXPT"_L001_R2_001.fastq"
  ##NEED TO TELL IT TO PUT EVERYTHING IN ANOTHER DIR
  echo "merging files..."
  echo "pear -f "$FW" -r "$RV" -o "$EXPT" > "$EXPT"-summary.txt"
  echo "Forward reads: "$FW""
  echo "Reverse reads: "$RV""
  pear -f $FW -r $RV -o $HOME/seqdata/merged/ARRPA/$EXPT > "$EXPT-summary.txt"
done



# for f in /$HOME/seqdata/unzipped/*.fastq; do
#   EXPT=$(basename "${f}" _L001_R1_001.fastq)
#
#   if $EXPT not in
#
#
#   end=5

for f in ./*.fastq.gz; do
  gunzip -c "${f}" > $HOME/seqdata/unzipped/"$(basename "${f}" .gz)"
done
