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
  mashes:
    type: Directory
    outputSource: return_mash_dir/out

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
    out: [taxcheck_folder, taxcheck_ouput]