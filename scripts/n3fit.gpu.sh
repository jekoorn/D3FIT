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
export LD_LIBRARY_PATH=/.singularity.d/libs
cd CURRENTDIRCHANGEINSCRIPT/$DIR

conda activate nnpdf-fit

istart="$IREP"
iend=$(( $istart + 15 )) # do 4 replicas

echo "$(date '+%Y-%m-%d %H:%M:%S') ${RUNCARD} -- ${istart}-${iend} -- GPU -- Submitted" \
    >> CURRENTDIRCHANGEINSCRIPT/submitted.fits

echo "n3fit ${RCFILE} {$istart} -r {$iend}"
n3fit "$RCFILE" "$istart" -r "$iend"

echo "$(date '+%Y-%m-%d %H:%M:%S') ${RUNCARD} -- ${istart}-${iend} -- GPU -- Completed" \
    >> CURRENTDIRCHANGEINSCRIPT/submitted.fits

