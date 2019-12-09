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
  faas: File[]
  limit_i: float
  limit_c: float

outputs:
  cat:
    type: File
    outputSource: concatenate/result

  mmseqs:
    type: Directory
    outputSource: mmseqs/outdir


steps:
  concatenate:
    run: ../utils/concatenate.cwl
    in:
      files: faas
      outputFileName: { default: 'prokka_cat' }
    out: [ result ]

  mmseqs:
    run: ../tools/mmseqs/mmseqs.cwl
    in:
      input_fasta: concatenate/result
      limit_i: limit_i
      limit_c: limit_c
    out: [ outdir ]