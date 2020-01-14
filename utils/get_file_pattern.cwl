cwlVersion: v1.0
class: ExpressionTool
requirements:
  SubworkflowFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  list_files: File[]
  pattern: string

outputs:
  file:
    type: File

expression: >
  ${
    var helpArray= [];
    for (var i = 0; i < inputs.list_files.length; i++) {
        if (inputs.list_files[i].nameroot.split(inputs.pattern).length > 1) {
            helpArray.push(inputs.list_files[i]);
      }}
    return { 'file' : helpArray[0] }
  }