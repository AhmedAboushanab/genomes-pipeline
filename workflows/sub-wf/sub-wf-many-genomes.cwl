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
  roary-fa:
    type: File
    outputSource: roary/pan_genome_reference-fa
  translate:
    type: File
    outputSource: translate/converted_faa

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
    out: [ pan_genome_reference-fa ]

  translate:
    run: ../../utils/translate_genes.cwl
    in:
      fa_file: roary/pan_genome_reference-fa
      faa_file: { default: 'pan_genome_reference.faa' }
    out: [ converted_faa ]

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
#    out: [annotations, seed_orthologs]