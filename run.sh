#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 3 ]; 
    then echo "Incorrect number of arguments. Usage: ./run.sh runcard_name batch_name mode={gpu,cpu}" >&2; exit 1 
fi

runcard="$1"
batch="$2"
mode="$3"     # gpu or cpu

# pick DAG file
case "$mode" in
    gpu) dag="DAG_GPU" ;;
    cpu) dag="DAG_CPU" ;;
    *) echo "mode must be gpu or cpu" >&2; exit 1 ;;
esac

tmp="${runcard/.yml/}"
RUNCARD_noyml="${tmp/.yaml/}"


dir=results/fit-${RUNCARD_noyml}
workingdir=$(pwd)
#workingdir=/data/theorie/jkoorn/nnpdf/fits/test_runall
mkdir -p $workingdir/$dir

# Check for .yaml or .yml
if [ -f "${runcard}" ]; then
    RCFILE="${runcard}"
else
    echo "Error: no runcard found for ${runcard} (.yaml or .yml)"
    exit 1
fi

cp $RCFILE $workingdir/$dir

mkdir -p $workingdir/$dir/testlogs
mkdir -p $workingdir/$dir/outfiles

# work inside target dir
cp scripts/* $workingdir/$dir
cd $workingdir/$dir


# substitute
tmp="${dag}.tmp"
sed "s/RUNCARD_ID_REPLACE_ME/${runcard}/g" "$dag" > "$tmp"
mv "$tmp" "$dag"

sed -i "s|CURRENTDIRCHANGEINSCRIPT|${workingdir}/results|g" evolve.sh
sed -i "s|CURRENTDIRCHANGEINSCRIPT|${workingdir}/results|g" vpsetupfit.sh
sed -i "s|CURRENTDIRCHANGEINSCRIPT|${workingdir}/results|g" n3fit.cpu.sh
sed -i "s|CURRENTDIRCHANGEINSCRIPT|${workingdir}/results|g" n3fit.gpu.sh

echo "******************************************************************"
echo "*"
echo "*"
echo "*             ██████╗ ██████╗ ███████╗██╗████████╗"
echo "*             ██╔══██╗╚════██╗██╔════╝██║╚══██╔══╝"
echo "*             ██║  ██║ █████╔╝█████╗  ██║   ██║"
echo "*             ██║  ██║ ╚═══██╗██╔══╝  ██║   ██║"
echo "*             ██████╔╝██████╔╝██║     ██║   ██║"
echo "*             ╚═════╝ ╚═════╝ ╚═╝     ╚═╝   ╚═╝"
echo "*"
echo "*"
echo "*  Starting D3FIT submission..."
echo "*"
echo "*  Runcard:  $runcard"
echo "*"
echo "*  Mode: ${dag}"
echo "*"
echo "*  Current path is: ${workingdir}"
echo "*"
echo "*  Writing results to: ${workingdir}/${dir}"
echo "*"
echo "******************************************************************"





# submit
condor_submit_dag -f -batch-name "$batch" "$dag"

cd ..
