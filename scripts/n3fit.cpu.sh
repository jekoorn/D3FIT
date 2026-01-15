#!/bin/bash

RUNCARD=$1
IREP=$2

tmp="${RUNCARD/.yml/}"
RUNCARD_noyml="${tmp/.yaml/}"
DIR=fit-$RUNCARD_noyml

# Check for .yaml or .yml
if [ -f "${RUNCARD}" ]; then
    RCFILE="${RUNCARD}"
else
    echo "Error: no runcard found for ${RUNCARD} (.yaml or .yml)"
    exit 1
fi


source ~/.bashrc
RUNCARDDIR=CURRENTDIRCHANGEINSCRIPT/$DIR/
cd $RUNCARDDIR

conda activate nnpdf-fit

# for i in $IREP_LIST; do
#     n3fit $RCFILE $i
#     echo "$(date '+%Y-%m-%d %H:%M:%S') ${RUNCARD} -- ${i} -- CPU" >> CURRENTDIRCHANGEINSCRIPT/submitted.fits
# done

istart="$IREP"
iend=$(( $istart + 23 )) # do 4 replicas

echo "$(date '+%Y-%m-%d %H:%M:%S') ${RUNCARD} -- ${istart}-${iend} -- CPU -- Submitted" \
    >> CURRENTDIRCHANGEINSCRIPT/submitted.fits

echo "n3fit ${RCFILE} {$istart} -r {$iend}"
n3fit "$RCFILE" "$istart" -r "$iend"

echo "$(date '+%Y-%m-%d %H:%M:%S') ${RUNCARD} -- ${istart}-${iend} -- CPU -- Completed" \
    >> CURRENTDIRCHANGEINSCRIPT/submitted.fits



