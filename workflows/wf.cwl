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
  checkm_csv:
    type: File
    outputSource: checkm2csv/csv
  gtdbtk:
    type: Directory
    outputSource: gtdbtk/gtdbtk_folder
  mmseqs:
    type: Directory
    outputSource: mmseqs/outdir

steps:

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
      taxcheck_outfolder: { default: 'taxcheck_dir'}
      taxcheck_outname: { default: 'taxcheck'}
    out: [taxcheck_folder, taxcheck_output]

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

  gtdbtk:
    run: ../tools/gtdbtk/gtdbtk.cwl
    in:
      drep_folder: drep/dereplicated_genomes
      gtdb_outfolder: { default: 'gtdb_outfolder' }
    out: [ gtdbtk_folder ]

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

  process_many_genomes:
    run: sub-wf/sub-wf-many-genomes.cwl
    scatter: cluster
    in:
      cluster: classify_clusters/many_genomes
    out:
      - prokka_faa-s

  process_one_genome:
    run: sub-wf/sub-wf-one-gemone.cwl
    scatter: cluster
    in:
      cluster: classify_clusters/one_genome
    out:
      - prokka_faa-s

  concatenate:
    run: ../utils/concatenate.cwl
    in:
      files:
        source:
          process_many_genomes/prokka_faa-s
          process_one_genome/prokka_faa-s
        linkMerge: merge_flattened
      outputFileName: { default: 'prokka_cat' }
    out: [ result ]

  mmseqs:
    run: ../tools/mmseqs/mmseqs.cwl
    in:
      input_fasta: concatenate/result
      limit_i: mmseqs_limit_i
      limit_c: mmseqs_limit_c
    out: [ outdir ]