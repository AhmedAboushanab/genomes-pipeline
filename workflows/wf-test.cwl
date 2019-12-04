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
  split: Directory

outputs:
  output_file:
    type: File[]
    outputSource: taxcheck/taxcheck_output
  output_folder:
    type: Directory[]
    outputSource: taxcheck/taxcheck_folder
steps:
  prep_step:
    run:
      class: ExpressionTool
      requirements: { InlineJavascriptRequirement: {} }
      inputs:
        dir: Directory
      expression: '${return {"files": inputs.dir.listing};}'
      outputs:
        files: File[]
    in:
      dir: split
    out: [files]

  taxcheck:
    run: ../tools/taxcheck/taxcheck.cwl
    scatter: genomes_fasta
    in:
      genomes_fasta: prep_step/files
      taxcheck_outfolder: { default: 'outdir'}
      taxcheck_outname: { default: 'outname'}
    out: [taxcheck_folder, taxcheck_output]