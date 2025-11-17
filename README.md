Usage:

Make an N3FIT runcard and put it in the D3FIT directory.

E.g. 

/D3FIT ~ ls
example-runcard.yml run.sh run_1_testfit.sh scripts

Then use by typing

./run.sh example-runcard batch-name mode

Where `mode` is one of `gpu` or `cpu` and `batch-name` is the label of the batch submit you want to pass to HTCondor.
