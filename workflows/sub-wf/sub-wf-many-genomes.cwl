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
  prokka_gffs:
    type: File[]
    outputSource: prokka/gff
  prokka_faa-s:
    type: File[]
    outputSource: prokka/faa
  roary-faa:
    type: File
    outputSource: roary/pan_genome_reference-faa
  roary-fa:
    type: File
    outputSource: roary/pan_genome_reference-fa

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
    out: [ gff, faa ]

  roary:
    run: ../../tools/roary/roary.cwl
    in:
      gffs: prokka/gff
      roary_outfolder: {default: 'roary_outfolder' }
    out:
      - pan_genome_reference-fa
      - pan_genome_reference-faa