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
  mash_input: File

outputs:
  tree:
    type: File
    outputSource: mash2tree/mash_tree

steps:
  mv:
    run: mv.cwl
    in:
      input_mash: mash_input
    out: [ mash ]
  mash2tree:
    run: mash2nwk.cwl
    in:
      input_mash: mv/mash
    out: [ mash_tree ]