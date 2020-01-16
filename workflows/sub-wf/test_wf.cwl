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
  many_genomes: Directory[]
  mash_folder: File[]
  mmseqs_limit_c: float
  mmseqs_limit_i: float[]

outputs:
  mash_trees:
    type: File[]
    outputSource: process_many_genomes/mash

steps:

# ----------- << many genomes cluster processing >> -----------
  process_many_genomes:
    run: test.cwl
    scatter: cluster
    in:
      cluster: many_genomes
      mash_files: mash_folder
    out: [ mash ]

