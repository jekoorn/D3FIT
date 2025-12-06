#!/bin/bash

source ~/.bashrc
conda activate nnpdf-fit

arg=$1
tmp="${arg/.yml/}"
RUNCARD="${tmp/.yaml/}"

FITPATH=CURRENTDIRCHANGEINSCRIPT/fit-$RUNCARD
cd $FITPATH


evolven3fit evolve $RUNCARD
postfit 100 $RUNCARD
cp -r $FITPATH/$RUNCARD /data/theorie/jkoorn/miniconda/envs/nnpdf-fit/share/NNPDF/results
