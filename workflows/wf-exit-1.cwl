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
  one_genome: Directory[]
  mmseqs_limit_c: float
  mmseqs_limit_i: float[]

outputs:
  mash_folder:
    type: Directory
    outputSource: return_mash_dir/out
  many_genomes:
    type: Directory[]
    outputSource: process_many_genomes/cluster_folder
  one_genome:
    type: Directory[]
    outputSource: process_one_genome/cluster_folder
  mmseqs:
    type: Directory
    outputSource: mmseqs/outdir

steps:

# ----------- << many genomes cluster processing >> -----------
  process_many_genomes:
    run: sub-wf/sub-wf-many-genomes.cwl
    scatter: cluster
    in:
      cluster: many_genomes
    out:
      - prokka_faa-s
      - cluster_folder

# ----------- << one genome cluster processing >> -----------
  process_one_genome:
    run: sub-wf/sub-wf-one-genome.cwl
    scatter: cluster
    in:
      cluster: one_genome
    out:
      - prokka_faa-s
      - cluster_folder

# ----------- << mash trees >> -----------
  process_mash:
    scatter: input_mash
    run: ../tools/mash2nwk/mash2nwk.cwl
    in:
      input_mash: mash_folder
    out: [mash_tree]

  return_mash_dir:
    run: ../utils/return_directory.cwl
    in:
      list: process_mash/mash_tree
      dir_name: { default: 'mash_trees' }
    out: [ out ]

# ----------- << mmseqs >> -----------

  flatten_many:
   run: ../utils/flatten_array.cwl
   in:
     arrayTwoDim: process_many_genomes/prokka_faa-s
   out: [array1d]

  concatenate:
    run: ../utils/concatenate.cwl
    in:
      files:
        source:
          - flatten_many/array1d
          - process_one_genome/prokka_faa-s
        linkMerge: merge_flattened
      outputFileName: { default: 'prokka_cat.fa' }
    out: [ result ]

  mmseqs:
    run: ../tools/mmseqs/mmseqs.cwl
    in:
      input_fasta: concatenate/result
      limit_i: mmseqs_limit_i
      limit_c: mmseqs_limit_c
    out: [ outdir ]
