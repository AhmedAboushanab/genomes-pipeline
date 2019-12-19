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
  limit_i: float
  limit_c: float

outputs:
  dir:
    type: Directory
    outputSource: return_folder/out


steps:
  mmseq:
    run: mmseqs.cwl
    in:
      input_fasta: input_fasta
      limit_i: limit_i
      limit_c: limit_c
    out: [ outdir ]

  return_folder:
    run: ../../utils/return_directory.cwl
    in:
      list: mmseq/outdir
      dir_name:
        source: ${inputs.limit_i}
         valueFrom: mmseq_output/mmseqs_${self}_dir
    out: [out]


