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
  mmseqs_limit_i: float

outputs:
  mash_trees:
    type: Directory
    outputSource: return_mash_dir/out

#  translate:
#    type: File[]
#    outputSource: process_many_genomes/translate

steps:

# ----------- << many genomes cluster processing >> -----------
#  process_many_genomes:
#    run: sub-wf/test.cwl
#    scatter: cluster
#    in:
#      cluster: many_genomes
#    out: [ translate ]


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


