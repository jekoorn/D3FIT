D(AG-N)3FIT

This is a script that automates the full NNPDF workflow (vp-setupfit, n3fit, evolven3fit, postfit) into one command and automatically launches a DAGMAN that monitors the fit.

I have hardcoded one path in `scripts/evolve.sh` that writes the fit result to my NNPDF results path. You will have to change this according to your liking.



Usage:

Make an N3FIT runcard and put it in the D3FIT directory.

E.g. 

/D3FIT ~ ls
example-runcard.yml run.sh run_1_testfit.sh scripts

Then use by typing

./run.sh example-runcard batch-name mode

Where `mode` is one of `gpu` or `cpu` and `batch-name` is the label of the batch submit you want to pass to HTCondor.

You only have to change the 
