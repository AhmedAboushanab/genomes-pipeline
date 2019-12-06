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
  eggnog_annotations:
    type: File
    outputSource: eggnog/annotations
  eggnog_seed_orthologs:
    type: File
    outputSource: eggnog/seed_orthologs

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

  eggnog:
    run: ../../tools/eggnog/eggnog.cwl
    in:
      fasta_file: prokka/faa
      outputname: { default: 'eggnog_result' }
    out: [annotations, seed_orthologs]