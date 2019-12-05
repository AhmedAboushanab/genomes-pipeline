#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

requirements:
  ResourceRequirement:
    ramMin: 250000
    coresMin: 32
  InlineJavascriptRequirement: {}
  ScatterFeatureRequirement: {}

baseCommand: [ mmseqs_wf.sh ]

arguments:
  - valueFrom: '32'
    prefix: -t
  - valueFrom: 'mmseqs'$(inputs.limit_i).toString()'_outdir'
    prefix: -o
  - valueFrom: (0.01*$(inputs.limit_c)).toString()
    prefix: -c
  - valueFrom: (0.01*$(inputs.limit_i)).toString()
    prefix: -i

inputs:
  input_fasta:
    type: File
    inputBinding:
      prefix: '-f'

  limit_i: int
  limit_c: int

outputs:
  outdir:
    type: Directory
    outputBinding:
      glob: 'mmseqs'$(inputs.limit_i).toString()'_outdir'
