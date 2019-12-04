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
  split: Directory

outputs:
  mashes:
    type: Directory
    outputSource: return_mash_dir/out

steps:
  classify_clusters:
    run: ../tools/drep/classify_folders.cwl
    in:
      clusters: split
    out: [many_genomes, one_genome, mash_folder]

  process_mash:
    scatter: input_mash
    run: ../tools/mash2nwk/mash2nwk.cwl
    in:
      input_mash: classify_clusters/mash_folder
    out: [mash_tree]

  return_mash_dir:
    run: ../utils/return_directory.cwl
    in:
      list: process_mash/mash_tree
      dir_name: { default: 'mash_trees' }
    out: [out]