#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: "checkm"

requirements:
  ResourceRequirement:
    ramMin: 500000
    coresMin: 2
  InlineJavascriptRequirement: {}
  ScatterFeatureRequirement: {}

baseCommand: ["gtdbtk", "classify_wf"]

arguments:
  - prefix: --cpus
    valueFrom: '2'
    position: 1
  - prefix: -x
    valueFrom: 'fa'
    position: 4

inputs:
  drep_folder:
    type: Directory
    inputBinding:
      position: 2
      prefix: '--genome_dir'
  gtdb_outfolder:
    type: string
    inputBinding:
      position: 3
      prefix: '--out_dir'

outputs:

  gtdbtk_folder:
    type: Directory
    outputBinding:
      glob: $(inputs.gtdb_outfolder)
