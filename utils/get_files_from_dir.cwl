#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: "checkm"

requirements:
  ResourceRequirement:
    ramMin: 50000
    coresMin: 16
  InlineJavascriptRequirement: {}
  ScatterFeatureRequirement: {}

baseCommand: [ls]


inputs:
  genomes:
    type: Directory
    inputBinding:
      position: 1

stdout: list.txt

outputs:
  stdout: stdout

  files:
    type: File[]
    outputBinding:
      glob: $(inputs.genomes.listing)

