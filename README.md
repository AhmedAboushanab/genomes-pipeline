# genomes-pipeline

### First part
**wf-1.cwl**

    1.1) checkm \
    1.2) checkm2csv \
    1.3) dRep \

    1.4.1) GTDB-Tk  \

    1.4.2) split_drep.py \
    1.5) classify_folders.py \

    2) taxcheck  \

output: OUTPUT_1
 - checkm_csv
 - gtdbtk folder
 - taxcheck_dirs
 
 
Check if many_genomes presented: **run wf-2-many.cwl**
### Second part

    1) Prokka
    2) Roary
    3) translate from fa to faa
    4.1) IPS
    4.2) EggNOG
    
output: OUTPUT_MANY
 - mash_trees
 - cluster folder(-s)
 - prokka concatenated faa result
 
Check if one_genome presented: **run wf-2-one.cwl**
### Third part

    1) Prokka
    2.1) IPS
    2.2) EggNOG
    
output: OUTPUT_ONE
 - cluster folder(-s)
 - prokka concatenated faa result

        
### Fourth part                                    
**wf-3.cwl**                             

    1) cat prokka from many and one
    2) mmseqs

output: OUTPUT_3
 - mmseqs folder
 
 
### Finally
Copy all outputs to one result folder