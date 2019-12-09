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
  mmseqs_limit_c: int
  mmseqs_limit_i: int

outputs:
  mash_trees:
    type: Directory
    outputSource: return_mash_dir/out
  taxcheck_dirs:
    type: Directory[]
    outputSource: taxcheck/taxcheck_folder
  checkm_csv:
    type: File
    outputSource: checkm2csv/csv
#  gtdbtk:
#    type: Directory
#    outputSource: gtdbtk/gtdbtk_folder
#  mmseqs:
#    type: Directory
#    outputSource: mmseqs/outdir

steps:
# ----------- << taxcheck >> -----------
  prep_taxcheck:
    run: ../utils/get_files_from_dir.cwl
    in:
      dir: genomes_folder
    out: [files]

  taxcheck:
    run: ../tools/taxcheck/taxcheck.cwl
    scatter: genomes_fasta
    in:
      genomes_fasta: prep_taxcheck/files
      taxcheck_outfolder: { default: 'taxcheck'}
      taxcheck_outname: { default: 'taxcheck'}
    out: [ taxcheck_folder ]

# ----------- << checkm >> -----------
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

# ----------- << drep >> -----------
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

  classify_clusters:
    run: ../tools/drep/classify_folders.cwl
    in:
      clusters: split_drep/split_out
    out: [many_genomes, one_genome, mash_folder]

# ----------- << many genomes cluster processing >> -----------

# ----------- << one genome cluster processing >> -----------

# ----------- << mash trees >> -----------
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
    out: [ out ]

# ----------- << GTDB - Tk >> -----------