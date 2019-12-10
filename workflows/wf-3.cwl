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
  prokka_many: File
  prokka_one: File
  mmseqs_limit_c: float
  mmseqs_limit_i: float

outputs:
  mmseqs:
    type: Directory
    outputSource: mmseqs/outdir

steps:
  concatenate:
    run: ../utils/concatenate.cwl
    in:
      files: [ prokka_many, prokka_one ]
      outputFileName: { default: 'prokka_cat.fa' }
    out: [ result ]

  mmseqs:
    run: ../tools/mmseqs/mmseqs.cwl
    in:
      input_fasta: concatenate/result
      limit_i: mmseqs_limit_i
      limit_c: mmseqs_limit_c
    out: [ outdir ]
