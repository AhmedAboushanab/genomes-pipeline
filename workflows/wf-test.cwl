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

steps:
  taxcheck:
    run: ../tools/taxcheck/taxcheck.cwl
    scatter: genomes_fasta
    in:
      genomes_fasta:
        source: split
        valueFrom: $(self.listing)
      taxcheck_outfolder: { default: 'outdir'}
      taxcheck_outname: { default: 'outname'}
    out: [taxcheck_folder, taxcheck_output]