#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

requirements:
  SubworkflowFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  genomes_folder: string
  checkm_res: File

outputs:
  checkm_csv:
    type: File
    outputSource: checkm2csv/csv
  drep:
    type: Directory
    outputSource: drep/out_folder


steps:
#  checkm:
#    run: ../tools/checkm/checkm.cwl
#    in:
#      input_folder: genomes_folder
#      checkm_outfolder: { default: 'checkm_outfolder' }
#    out: [ stdout, out_folder ]

  checkm2csv:
    run: ../tools/checkm/checkm2csv.cwl
    in:
      out_checkm: checkm_res #checkm/stdout
    out: [ csv ]

  drep:
    run: ../tools/drep/drep.cwl
    in:
      genomes: genomes_folder
      drep_outfolder: { default: 'drep_outfolder' }
      checkm_csv: checkm2csv/csv
    out: [ out_folder ]
