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

outputs:
  mash_trees:
    type: Directory
    outputSource: return_mash_dir/out

  many_genomes_result:
    type: Directory[]
    outputSource: process_many_genomes/cluster_folder

  prokka_cat_many:
    type: File
    outputSource: concatenate/result


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

# ----------- << prep mmseqs >> -----------

  flatten_many:
   run: ../utils/flatten_array.cwl
   in:
     arrayTwoDim: process_many_genomes/prokka_faa-s
   out: [array1d]

  concatenate:
    run: ../utils/concatenate.cwl
    in:
      files: flatten_many/array1d
      outputFileName: { default: 'prokka_many.fa' }
    out: [ result ]
