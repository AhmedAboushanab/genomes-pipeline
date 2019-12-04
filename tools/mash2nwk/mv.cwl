#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

requirements:
  ResourceRequirement:
    ramMin: 10000
    coresMin: 4
  InlineJavascriptRequirement: {}
  ScatterFeatureRequirement: {}

baseCommand: [mv]

inputs:
  input_mash:
    type: File
    inputBinding:
      position: 1

arguments:
  - valueFrom: "file.mash"
    position: 2

outputs:
  mash:
    type: File
    outputBinding:
      glob: "file.mash"