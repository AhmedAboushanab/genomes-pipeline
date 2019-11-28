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
  split_drep:
    type: Directory
    outputSource: split_drep/split_out
  gtdbtk:
    type: Directory
    outputSource: gtdbtk/gtdbtk_folder

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
    out: [ out_folder, dereplicated_genomes ]

  split_drep:
    run: ../tools/drep/split_drep.cwl
    in:
      genomes_folder: genomes_folder
      drep_folder: drep/out_folder
      split_outfolder: { default: 'split_outfolder' }
    out: [ split_out ]

  gtdbtk:
    run: ../tools/gtdbtk/gtdbtk.cwl
    in:
      drep_folder: drep/dereplicated_genomes
      gtdb_outfolder: { default: 'gtdb_outfolder' }
    out: [ gtdbtk_folder ]

