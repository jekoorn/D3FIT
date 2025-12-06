#!/bin/bash


RUNCARD=$1
shift
IREP_LIST="$@"

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

#for i in $IREP_LIST; do
#    n3fit $RCFILE $i
#    echo "$(date '+%Y-%m-%d %H:%M:%S') ${RUNCARD} -- ${i} -- GPU" >> CURRENTDIRCHANGEINSCRIPT/submitted.fits
#done

ilow=$(printf "%s\n" $IREP_LIST | sort -n | head -1)
ihigh=$(printf "%s\n" $IREP_LIST | sort -n | tail -1)

n3fit "$RCFILE" "$ilow" -r "$ihigh"

echo "$(date '+%Y-%m-%d %H:%M:%S') ${RUNCARD} -- ${ilow}-${ihigh} -- GPU" \
    >> CURRENTDIRCHANGEINSCRIPT/submitted.fits


