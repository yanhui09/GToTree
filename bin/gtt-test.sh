#!/usr/bin/env bash
set -e

# setting colors to use
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

printf "\n"
printf "  ${GREEN}Downloading GToTree test data into the subdirectory ${YELLOW}GToTree-test-data/\n\n${NC}"
printf "  ${GREEN}Data being pulled from here:\n${NC}"
printf "    ${YELLOW}https://figshare.com/articles/dataset/GToTree_test_data/19372334${NC}\n\n\n"

curl -L -o GToTree-test-data.tar.gz https://figshare.com/ndownloader/files/34404560
tar -xf GToTree-test-data.tar.gz
rm GToTree-test-data.tar.gz

printf "\n\n"

TEST_DATA_DIR="GToTree-test-data"

## modifying paths of input genomes in input files as needed (not using sed -i so compatible with darwin sed too)

sed "s/^/${TEST_DATA_DIR}\//" ${TEST_DATA_DIR}/genbank_files.txt > ${TEST_DATA_DIR}/genbank_files.txt.tmp && mv ${TEST_DATA_DIR}/genbank_files.txt.tmp ${TEST_DATA_DIR}/genbank_files.txt
sed "s/^/${TEST_DATA_DIR}\//" ${TEST_DATA_DIR}/fasta_files.txt > ${TEST_DATA_DIR}/fasta_files.txt.tmp && mv ${TEST_DATA_DIR}/fasta_files.txt.tmp ${TEST_DATA_DIR}/fasta_files.txt
sed "s/^/${TEST_DATA_DIR}\//" ${TEST_DATA_DIR}/amino_acid_files.txt > ${TEST_DATA_DIR}/amino_acid_files.txt.tmp && mv ${TEST_DATA_DIR}/amino_acid_files.txt.tmp ${TEST_DATA_DIR}/amino_acid_files.txt

printf "  ${GREEN}Running test as:\n${NC}"
printf "    ${YELLOW}GToTree -a ${TEST_DATA_DIR}/ncbi_accessions.txt "'\\ \n'
printf "            -g ${TEST_DATA_DIR}/genbank_files.txt "'\\ \n'
printf "            -f ${TEST_DATA_DIR}/fasta_files.txt "'\\ \n'
printf "            -A ${TEST_DATA_DIR}/amino_acid_files.txt "'\\ \n'
printf "            -m ${TEST_DATA_DIR}/genome_to_id_map.tsv "'\\ \n'
printf "            -p ${TEST_DATA_DIR}/pfam_targets.txt "'\\ \n'
printf "            -H Universal -t -D -j 4 -o GToTree-test-output -F\n\n${NC}"

sleep 2

printf "  ${YELLOW}The test run includes some things that shouldn't be found, so\n"
printf "  don't be alarmed when seeing those messages.${NC}\n\n"

sleep 2

printf "  ${GREEN}Starting run now:\n${NC}"

GToTree -a ${TEST_DATA_DIR}/ncbi_accessions.txt -g ${TEST_DATA_DIR}/genbank_files.txt -f ${TEST_DATA_DIR}/fasta_files.txt -A ${TEST_DATA_DIR}/amino_acid_files.txt -H Universal -m ${TEST_DATA_DIR}/genome_to_id_map.tsv -p ${TEST_DATA_DIR}/pfam_targets.txt -t -D -j 4 -o GToTree-test-output -F

if [ -d "GToTree-test-output/" ]; then

    printf "\n ${YELLOW}_______________________________________________________________________________${NC}\n\n"
    printf "\n  ${GREEN}Test completed! See here for how things should look:\n${NC}"
    printf "    ${YELLOW}https://github.com/AstrobioMike/GToTree/wiki/Installation#test-run${NC}\n\n"

else

    printf "\n ${YELLOW}_______________________________________________________________________________${NC}\n\n"
    printf "\n  ${RED}There seems to have been a problem with the test run :(\n${NC}"
    printf "    ${YELLOW}If this continues, please consider submitting an issue here:\n${NC}"
    printf "        ${YELLOW}https://github.com/AstrobioMike/GToTree/issues${NC}\n\n"

    printf "  ${GREEN}You can clear out the test data and results by running:${NC}\n"
    printf "    ${YELLOW}gtt-clean-after-test.sh\n\n${NC}"

fi

printf "  ${GREEN}You can clear out the test data and results by running:${NC}\n"
printf "    ${YELLOW}gtt-clean-after-test.sh\n\n${NC}"
