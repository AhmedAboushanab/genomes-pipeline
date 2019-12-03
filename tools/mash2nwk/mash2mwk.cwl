#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: "mash2nwk"

requirements:
  ResourceRequirement:
    ramMin: 10000
    coresMin: 4
  InlineJavascriptRequirement: {}
  ScatterFeatureRequirement: {}

baseCommand: ["mash2nwk.R"]

inputs:
  input_mash:
    type: string
    inputBinding:
      position: 1
      prefix: '-m'

outputs: []
