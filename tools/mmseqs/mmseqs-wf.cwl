#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

requirements:
  SubworkflowFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  input_fasta: File
  limit_i: float[]
  limit_c: float

outputs:
  dir:
    type: Directory
    outputSource: return_folder/pool_directory


steps:
  mmseq:
    run: mmseqs.cwl
    scatter: limit_i
    in:
      input_fasta: input_fasta
      limit_i: limit_i
      limit_c: limit_c
    out: [ outdir ]

  return_folder:
    run: ../../utils/return_dir_of_dir.cwl
    in:
      directory_array: mmseq/outdir
      newname: {default: 'mmseqs_output'}
    out: [pool_directory]


