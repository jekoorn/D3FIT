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
    gpu) dag="DAG_GPU" && fit="n3fit.gpu.sub" ;;
    cpu) dag="DAG_CPU" && fit="n3fit.cpu.sub" ;;
    *) echo "mode must be gpu or cpu" >&2; exit 1 ;;
esac

echo $fit

dir=fit-${runcard}
workingdir=$(pwd)
#workingdir=/data/theorie/jkoorn/nnpdf/fits/test_runall
mkdir -p $workingdir/$dir

# Check for .yaml or .yml
if [ -f "${runcard}.yaml" ]; then
    RCFILE="${runcard}.yaml"
elif [ -f "${runcard}.yml" ]; then
    RCFILE="${runcard}.yml"
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

#pushd "$dir" >/dev/null

# substitute
tmp="${dag}.tmp"
sed "s/RUNCARD_ID_REPLACE_ME/${runcard}/g" "$dag" > "$tmp"
mv "$tmp" "$dag"
tmp="${dag}.tmp"
sed "s/seq 1 130/seq 1 10/g" "$fit" > "$tmp"
mv "$tmp" "$fit"

sed -i "s|CURRENTDIRCHANGEINSCRIPT|${workingdir}|g" evolve.sh
sed -i "s|CURRENTDIRCHANGEINSCRIPT|${workingdir}|g" vpsetupfit.sh
sed -i "s|CURRENTDIRCHANGEINSCRIPT|${workingdir}|g" n3fit.cpu.sh
sed -i "s|CURRENTDIRCHANGEINSCRIPT|${workingdir}|g" n3fit.gpu.sh

# submit
condor_submit_dag -f -batch-name "$batch" "$dag"

# restore original DAG
#sed "s/${runcard}/RUNCARD_ID_REPLACE_ME/g" "$dag" > "$tmp"
#mv "$tmp" "$dag"
cd ..
