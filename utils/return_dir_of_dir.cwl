cwlVersion: v1.0
class: ExpressionTool
label: Returns a directory named after inputs.newname, containing all input files and directories.

requirements:
  InlineJavascriptRequirement: {}

inputs:
  directory_array:
    type: Directory[]
  newname:
    type: string

outputs:
  pool_directory:
    type: Directory

expression: |
  ${
    return {
      "pool_directory": {
        "class": "Directory",
        "basename": inputs.newname,
        "listing": inputs.directory_array.listing
      }
    };
  }