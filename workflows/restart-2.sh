#!/bin/bash

# max limit of memory that would be used by toil to restart
export MEMORY=20G
# number of cores to run toil
export NUM_CORES=8
# clone of pipeline-v5 repo
export PIPELINE_FOLDER=/hps/nobackup2/production/metagenomics/databases/human-gut_resource/cwl_pipeline/genomes-pipeline

while getopts :m:n:c:a:g: option; do
	case "${option}" in
		m) MEMORY=${OPTARG};;
		n) NUM_CORES=${OPTARG};;
		c) CUR_DIR=${OPTARG};;
		a) NAME_RUN=${OPTARG};;
		y) YML=${OPTARG};;
	esac
done

# --------------------------------- 1 ---------------------------------
echo "Activating envs"
source /hps/nobackup/production/metagenomics/software/toil-venv/bin/activate
source /nfs/production/interpro/metagenomics/mags-scripts/annot-config
export PATH=$PATH:/homes/emgpr/.nvm/versions/node/v12.10.0/bin/

echo "Set folders"
export WORK_DIR=${CUR_DIR}/work-dir
export JOB_TOIL_FOLDER_1=${WORK_DIR}/job-store-wf-1
export JOB_TOIL_FOLDER_2=${WORK_DIR}/job-store-wf-2
export OUT_DIR=${CUR_DIR}
export LOG_DIR=${OUT_DIR}/log-dir/${NAME_RUN}
export TMPDIR=${WORK_DIR}/temp-dir/${NAME_RUN}
export OUT_DIR_FINAL=${OUT_DIR}/results/${NAME_RUN}

echo "Create empty ${LOG_DIR} and YML-file"
export OUT_TOOL_1=${OUT_DIR_FINAL}_1
export OUT_TOOL_2=${OUT_DIR_FINAL}_2

export JOB_GROUP=genome_pipeline
bgadd -L 50 /${USER}_${JOB_GROUP} > /dev/null
bgmod -L 50 /${USER}_${JOB_GROUP} > /dev/null
export TOIL_LSF_ARGS="-g /${USER}_${JOB_GROUP} -P bigmem"  #-q production-rh74

export CWL=$PIPELINE_FOLDER/workflows/wf-1.cwl
export CWL_BOTH=$PIPELINE_FOLDER/workflows/wf-exit-1.cwl
export CWL_MANY=$PIPELINE_FOLDER/workflows/wf-exit-2.cwl
export CWL_ONE=$PIPELINE_FOLDER/workflows/wf-exit-3.cwl


cd $WORK_DIR && \
time cwltoil \
  --restart \
  --no-container \
  --batchSystem LSF \
  --disableCaching \
  --defaultMemory $MEMORY \
  --defaultCores $NUM_CORES \
  --jobStore $JOB_TOIL_FOLDER_2/${NAME_RUN} \
  --outdir $OUT_TOOL_2 \
  --retryCount 3 \
  --logFile $LOG_DIR/${NAME_RUN}_2.log \
${CWL_BOTH} ${YML} > ${OUT_TOOL_2}/out2.json