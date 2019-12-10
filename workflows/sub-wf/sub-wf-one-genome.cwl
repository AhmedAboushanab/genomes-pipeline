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

  cluster_folder:
    type: Directory
    outputSource: create_cluster_folder/out

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
      outdirname:
        source: cluster
        valueFrom: $(self.basename)_prokka
    out: [ faa ]

  IPS:
    run: ../../tools/IPS/InterProScan.cwl
    in:
      inputFile:
        source: prokka/faa
        valueFrom: $(self[0].location.split(':')[1])
    out: [annotations]

  eggnog:
    run: ../../tools/eggnog/eggnog.cwl
    in:
      fasta_file:
        source: prokka/faa
        valueFrom: $(self[0].location.split(':')[1])
      outputname:
        source: cluster
        valueFrom: $(self.basename)
    out: [annotations, seed_orthologs]

  create_cluster_folder:
    run: ../../utils/return_directory.cwl
    in:
      list:
        - IPS/annotations
        - eggnog/annotations
        - eggnog/seed_orthologs
      dir_name:
        source: cluster
        valueFrom: cluster_$(self.basename)
    out: [ out ]