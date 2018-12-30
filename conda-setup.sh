#!/usr/bin/env bash

# setting colors to use
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

printf "\n    ${GREEN}Setting up conda environment...${NC}\n\n"

## adding conda channels
conda config --add channels defaults 2> /dev/null
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --add channels au-eoed

## creating GToTree environment and installing dependencies
conda create -n gtotree biopython hmmer muscle trimal fasttree prodigal taxonkit gnu-parallel --yes

## activating environment
source activate gtotree

## creating directory for conda-env-specific source files
mkdir -p ${CONDA_PREFIX}/etc/conda/activate.d

## adding GToTree bin path and GToTree_HMM_dir variable:
echo '#!/bin/sh'" \


export PATH=\"$(pwd)/bin:"'$PATH'\"" \

export GToTree_HMM_dir=\"$(pwd)/hmm_sets\"" >> ${CONDA_PREFIX}/etc/conda/activate.d/env_vars.sh

printf "\n    ${GREEN}Setting up taxonkit...${NC}\n\n"

## downloading ncbi tax database for taxonkit and setting variable
mkdir -p ncbi_tax_info
cd ncbi_tax_info

curl --retry 10 -O ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz
tar -xzvf taxdump.tar.gz
rm taxdump.tar.gz

echo "export TAXONKIT_DB=$(pwd)" >> ${CONDA_PREFIX}/etc/conda/activate.d/env_vars.sh

cd ../

# re-activating environment so variable and PATH changes take effect
source activate gtotree

printf "\n        ${GREEN}DONE!${NC}\n\n"