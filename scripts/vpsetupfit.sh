#!/bin/bash

source ~/.bashrc
RUNCARD=$1
DIR=fit-$RUNCARD


# Check for .yaml or .yml
if [ -f "${RUNCARD}.yaml" ]; then
    RCFILE="${RUNCARD}.yaml"
elif [ -f "${RUNCARD}.yml" ]; then
    RCFILE="${RUNCARD}.yml"
else
    echo "Error: no runcard found for ${RUNCARD} (.yaml or .yml)"
    exit 1
fi


RCPATH=CURRENTDIRCHANGEINSCRIPT/$DIR/$RUNCARD
cd $RCPATH

conda activate nnpdf-fit
vp-setupfit $RCFILE
