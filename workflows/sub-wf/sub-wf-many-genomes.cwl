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
        valueFrom: cluster_$(self.basename)/prokka_outfolder
    out: [ gff, faa, outdir ]

  roary:
    run: ../../tools/roary/roary.cwl
    in:
      gffs: prokka/gff
      roary_outfolder:
        source: cluster
        valueFrom: cluster_$(self.basename)/roary_outfolder
    out: [ pan_genome_reference-fa, roary_dir ]

  translate:
    run: ../../utils/translate_genes.cwl
    in:
      fa_file: roary/pan_genome_reference-fa
      faa_file:
        source: cluster
        valueFrom: $(self.basename)_pan_genome_reference.faa
    out: [ converted_faa ]

  IPS:
    run: ../../tools/IPS/InterProScan.cwl
    in:
      inputFile: translate/converted_faa
    out: [annotations]

  eggnog:
    run: ../../tools/eggnog/eggnog.cwl
    in:
      fasta_file: translate/converted_faa
      outputname:
        source: cluster
        valueFrom: $(self.basename)
    out: [annotations, seed_orthologs]

  create_cluster_folder:
    run: ../../utils/return_directory.cwl
    in:
      list:
        - translate/converted_faa
        - IPS/annotations
        - eggnog/annotations
        - eggnog/seed_orthologs
      dir_name:
        source: cluster
        valueFrom: cluster_$(self.basename)
    out: [ out ]