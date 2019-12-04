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
  genomes_folder: Directory

outputs:
  checkm_outfolder:
    type: Directory
    outputSource: checkm/out_folder
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

  # add taxcheck

  checkm:
    run: ../tools/checkm/checkm.cwl
    in:
      input_folder: genomes_folder
      checkm_outfolder: { default: 'checkm_outfolder' }
    out: [ stdout, out_folder ]

  checkm2csv:
    run: ../tools/checkm/checkm2csv.cwl
    in:
      out_checkm: checkm/stdout
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

  classify_clusters:
    run: ../tools/drep/classify_folders.cwl
    in:
      clusters: split_drep/split_out
    out: [many_genomes, one_genome, mash_folder]

  process_mash:
    scatter: input_mash
    run: ../tools/mash2nwk/mash2nwk.cwl
    in:
      input_mash: classify_clusters/mash_folder
    out: [mash_tree]

  return_mash_dir:
    run: ../utils/return_directory.cwl
    in:
      list: process_mash/mash_tree
      dir_name: { default: 'mash_trees' }
    out: [out]

  process_many_genomes:
    run: sub-wf/sub-wf-many-genomes.cwl
    in:

    out:

  process_one_genome:
    run: sub-wf/sub-wf-one-gemone.cwl
    in:

    out: