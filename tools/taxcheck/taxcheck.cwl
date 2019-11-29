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
  genomes_fasta:
    type: string
    inputBinding:
      position: 2
      prefix: '-i'

  taxcheck_outfolder:
    type: string
    inputBinding:
      position: 3
      prefix: '-d'

  taxcheck_outname:
    type: string
    inputBinding:
      position: 4
      prefix: '-o'

outputs:

  taxcheck_folder:
    type: Directory
    outputBinding:
      glob: $(inputs.taxcheck_outfolder)

  taxcheck_ouput:
    type: File
    outputBinding:
      glob: $(inputs.taxcheck_outname)