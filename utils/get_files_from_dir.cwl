class: CommandLineTool
cwlVersion: v1.0
requirements:
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement
#  - class: InitialWorkDirRequirement
#    listing: |
#      ${return {'type': 'array', 'items': [ inputs.genomes.listing ]};}

inputs:
  genomes: Directory

stdout: me.txt

outputs:
  outlist:
    type: File[]
    secondaryFiles: $(inputs.genomes.listing)

#arguments: ["find", ".",
#  {shellQuote: false, valueFrom: "|"},
#  "sort"]