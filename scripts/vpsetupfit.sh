#!/bin/bash

source ~/.bashrc
RUNCARD=$1

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


RCPATH=CURRENTDIRCHANGEINSCRIPT/$DIR/$RUNCARD
cd $RCPATH

conda activate nnpdf-fit
vp-setupfit $RCFILE
