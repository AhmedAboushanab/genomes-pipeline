class: CommandLineTool
cwlVersion: v1.0
requirements:
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement
  - class: InitialWorkDirRequirement
    listing: |
      ${return {'type': 'array', 'items': [ inputs.empty ]};}

inputs:
  genomes: Directory

outputs:
  outlist: stdout