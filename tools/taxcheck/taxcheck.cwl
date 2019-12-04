#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: "taxcheck"

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
    type: File
    inputBinding:
      position: 2
      prefix: '-c'

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

  taxcheck_output:
    type: File
    outputBinding:
      glob: $(inputs.taxcheck_outname)