#!/bin/bash

source /hps/nobackup/production/metagenomics/software/toil-venv/bin/activate
source /nfs/production/interpro/metagenomics/mags-scripts/annot-config
export PATH=$PATH:/homes/emgpr/.nvm/versions/node/v12.10.0/bin/

export MEMORY=20G
export NUM_CORES=8

export WORK_DIR=/hps/nobackup2/production/metagenomics/pipeline/testing/kate_work
export OUT_DIR=/hps/nobackup2/production/metagenomics/pipeline/testing/kate_out
export PIPELINE_FOLDER=/hps/nobackup2/production/metagenomics/databases/human-gut_resource/cwl_pipeline/genomes-pipeline

export NAME_RUN=test-new-exit2
export CWL=$PIPELINE_FOLDER/workflows/wf-exit-2.cwl
export YML=$PIPELINE_FOLDER/workflows/test-2.yml

# < set up folders >
export JOB_TOIL_FOLDER=$WORK_DIR/$NAME_RUN/
export LOG_DIR=${OUT_DIR}/logs_${NAME_RUN}
export TMPDIR=${WORK_DIR}/global-temp-dir_${NAME_RUN}
export OUT_TOOL=${OUT_DIR}/${NAME_RUN}

export TOIL_LSF_ARGS="-P bigmem"

echo " === Running first part === "

mkdir -p $JOB_TOIL_FOLDER $LOG_DIR $TMPDIR $OUT_TOOL && \
cd $WORK_DIR && \
rm -rf $JOB_TOIL_FOLDER $OUT_TOOL/* $LOG_DIR/* && \
time cwltoil \
  --no-container \
  --batchSystem LSF \
  --disableCaching \
  --defaultMemory $MEMORY \
  --jobStore $JOB_TOIL_FOLDER \
  --outdir $OUT_TOOL \
  --logFile $LOG_DIR/${NAME_RUN}_1.log \
  --defaultCores $NUM_CORES \
  --writeLogs ${LOG_DIR} \
${CWL} ${YML} > ${OUT_TOOL}/out.json
