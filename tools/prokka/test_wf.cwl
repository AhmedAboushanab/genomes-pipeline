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
  fa_file: File

outputs:

  prokka:
    type: Directory
    outputSource: return_dir/pool_directory

steps:
  prokka:
    run: prokka.cwl
    in:
      fa_file: fa_file
      outdirname: { default: prokka }
    out: [ outdir ]

  return_dir:
    run: ../../utils/return_dir_of_dir.cwl
    in:
      directory_array:
        linkMerge: merge_nested
        source:
          - prokka/outdir
      newname: { default: cluster }
    out: [pool_directory]