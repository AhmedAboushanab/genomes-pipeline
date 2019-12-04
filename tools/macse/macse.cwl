#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

requirements:
  ResourceRequirement:
    ramMin: 10000
    coresMin: 16
  InlineJavascriptRequirement: {}
  ScatterFeatureRequirement: {}

baseCommand: ["java", "-jar", "/nfs/production/interpro/metagenomics/mags-scripts/scripts/macse_v2.03.jar"]

arguments:
  - valueFrom: 'translateNT2AA'
    prefix: '-prog'
    position: 1
  - valueFrom: '11'
    prefix: '-gc_def'
    position: 3

inputs:
  fa_file:
    type: File
    inputBinding:
      position: 2
      prefix: '-seq'
  faa_file:
    type: File
    inputBinding:
      position: 4
      prefix: '-out_AA'

outputs: []
