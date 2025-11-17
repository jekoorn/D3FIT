#!/bin/bash

source ~/.bashrc
conda activate nnpdf-fit

RUNCARD=$1
FITPATH=CURRENTDIRCHANGEINSCRIPT/fit-$RUNCARD
cd $FITPATH


evolven3fit evolve $RUNCARD
postfit 100 $RUNCARD
cp -r $FITPATH/$RUNCARD /data/theorie/jkoorn/miniconda/envs/nnpdf-fit/share/NNPDF/results
