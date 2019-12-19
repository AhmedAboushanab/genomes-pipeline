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
  one_genome: Directory[]
  mmseqs_limit_c: float
  mmseqs_limit_i: float[]

outputs:
  one_genome_result:
    type: Directory[]
    outputSource: process_one_genome/cluster_folder

  mmseqs:
    type: Directory
    outputSource: return_mmseq_dir/out

steps:

# ----------- << one genome cluster processing >> -----------
  process_one_genome:
    run: sub-wf/sub-wf-one-genome.cwl
    scatter: cluster
    in:
      cluster: one_genome
    out:
      - prokka_faa-s
      - cluster_folder

# ----------- << prep mmseqs >> -----------

  concatenate:
    run: ../utils/concatenate.cwl
    in:
      files: process_one_genome/prokka_faa-s
      outputFileName: { default: 'prokka_one.fa' }
    out: [ result ]

  mmseqs:
    run: ../tools/mmseqs/mmseqs.cwl
    scatter: limit_i
    in:
      input_fasta: concatenate/result
      limit_i: mmseqs_limit_i
      limit_c: mmseqs_limit_c
    out: [ outdir ]

  return_mmseq_dir:
    run: ../utils/return_dir_of_dir.cwl
    in:
      list: mmseqs/outdir
      dir_name: { default: "mmseqs_output" }
    out: [ out ]