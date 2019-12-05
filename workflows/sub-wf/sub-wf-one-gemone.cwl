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
  cluster: Directory

outputs:

  prokka_faa-s:
    type: File[]
    outputSource: prokka/faa

#  IPS_result:
#    type: File
#    outputSource: IPS/annotations
#
#  eggnog_result:
#    type: File
#    outputSource: eggnog/output
#  eggnog_result_dir:
#    type: Directory
#    outputSource: eggnog/output_dir

steps:
  preparation:
    run: ../../utils/get_files_from_dir.cwl
    in:
      dir: cluster
    out: [files]

  prokka:
    run: ../../tools/prokka/prokka.cwl
    scatter: fa_file
    in:
      fa_file: preparation/files
      outdirname: { default: 'prokka'}
    out: [faa]

#  IPS:
#    run: ../../tools/IPS/InterProScan.cwl
#    in:
#      inputFile: prokka/faa
#    out: [annotations]

#  eggnog:
#    run: ../../tools/eggnog/eggnog.cwl
#    in:
#      fasta_file: prokka/faa
#      outputname: { default: 'eggnog_result' }
#      output_dir: { default: 'eggnog_outdit' }
#      tmp_dir: { default: 'eggnog_tmp' }
#    out: [output, output_dir]