#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: "checkm"

requirements:
  ResourceRequirement:
    ramMin: 20000
    coresMin: 4
  InlineJavascriptRequirement: {}
  ScatterFeatureRequirement: {}

baseCommand: ["taxcheck.sh"]

arguments:
  - prefix: -t
    valueFrom: '4'
    position: 1

inputs:
  genomes:
    type: string

  drep_outfolder:
    type: string
    inputBinding:
      position: 2

  checkm_csv:
    type: File
    inputBinding:
      position: 8
      prefix: '--genomeInfo'

stdout: checkm.out

outputs:

  out_folder:
    type: Directory
    outputBinding:
      glob: $(inputs.drep_outfolder)