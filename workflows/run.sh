#!/bin/bash

source /nfs/production/interpro/metagenomics/mags-scripts/annot-config
source /hps/nobackup2/production/metagenomics/pipeline/testing/kate/toil-3.19.0/bin/activate
export PATH=$PATH:/homes/emgpr/.nvm/versions/node/v12.10.0/bin/

export MEMORY=20G
export NUM_CORES=8

export WORK_DIR=/hps/nobackup2/production/metagenomics/pipeline/testing/kate_work
export OUT_DIR=/hps/nobackup2/production/metagenomics/pipeline/testing/kate_out
export PIPELINE_FOLDER=/hps/nobackup2/production/metagenomics/databases/human-gut_resource/cwl_pipeline/genomes-pipeline

export NAME_RUN=genomes-pipeline
export CWL=$PIPELINE_FOLDER/workflows/wf-1.cwl
export YML=$PIPELINE_FOLDER/workflows/wf-1.yml

# < set up folders >
export JOB_TOIL_FOLDER=$WORK_DIR/$NAME_RUN/
export LOG_DIR=${OUT_DIR}/logs_${NAME_RUN}
export TMPDIR=${WORK_DIR}/global-temp-dir_${NAME_RUN}
export OUT_TOOL_1=${OUT_DIR}/${NAME_RUN}_1

export TOIL_LSF_ARGS="-P bigmem"

echo " === Running first part === "

mkdir -p $JOB_TOIL_FOLDER $LOG_DIR $TMPDIR $OUT_TOOL_1 && \
cd $WORK_DIR && \
rm -rf $JOB_TOIL_FOLDER $OUT_TOOL_1/* $LOG_DIR/* && \
time cwltoil \
  --no-container \
  --batchSystem LSF \
  --disableCaching \
  --logDebug \
  --defaultMemory $MEMORY \
  --jobStore $JOB_TOIL_FOLDER \
  --outdir $OUT_TOOL_1 \
  --logFile $LOG_DIR/${NAME_RUN}.log \
  --defaultCores $NUM_CORES \
  --writeLogs ${LOG_DIR} \
${CWL} ${YML} > ${OUT_TOOL_1}/out1.json

echo " === Parsing first output folder === "

export YML_2=${OUT_DIR}/logs_${NAME_RUN}/wf-2.yml
python3 $PIPELINE_FOLDER/workflows/parser_yml.py -j ${OUT_TOOL_1}/out1.json -y ${YML_2}
export EXIT_CODE=$?
echo ${EXIT_CODE}

echo "
mmseqs_limit_i: 1
mmseqs_limit_c: 0.8" >> ${YML_2}

echo "Yml file ${YML_2}"

if [ ${EXIT_CODE} -eq 1 ]
then
    echo "Running many and one genomes sub-wf"
fi
if [ ${EXIT_CODE} -eq 2 ]
then
    echo "Running many genomes sub-wf"
fi
if [ ${EXIT_CODE} -eq 3 ]
then
    echo "Running one genome sub-wf"
fi
if [ ${EXIT_CODE} -eq 4 ]
then
    echo "Something very strange happened"
fi
# copy csv from 1 folder