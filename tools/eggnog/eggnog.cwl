#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: "eggNOG"

hints:
  DockerRequirement:
    dockerPull: eggnog_pipeline:latest

requirements:
  ResourceRequirement:
    ramMin: 20000
    coresMin: 16
#  InlineJavascriptRequirement: {}

baseCommand: [emapper.py]

arguments:
  - valueFrom: '16'
    prefix: '--cpu'
  - valueFrom: 'diamond'
    prefix: '-m'

inputs:
  fasta_file:
    type: File
    inputBinding:
      separate: true
      prefix: -i
    label: Input FASTA file containing query sequences

  outputname:
    type: string
    inputBinding:
      prefix: -o

  output_dir:
    type: string
    inputBinding:
      prefix: --output_dir

  tmp_dir:
    type: string
    inputBinding:
      prefix: --temp_dir

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.outputname)

  output_dir:
    type: Directory
    outputBinding:
      glob: $(inputs.output_dir)
