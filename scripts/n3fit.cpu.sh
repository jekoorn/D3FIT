#!/bin/bash

RUNCARD=$1
IREP=$2
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


source ~/.bashrc
RUNCARDDIR=CURRENTDIRCHANGEINSCRIPT/$DIR/
cd $RUNCARDDIR

conda activate nnpdf-fit
n3fit $RCFILE $IREP

echo "$(date '+%Y-%m-%d %H:%M:%S') ${RUNCARD} -- ${IREP} -- CPU" >> CURRENTDIRCHANGEINSCRIPT/submitted.fits
