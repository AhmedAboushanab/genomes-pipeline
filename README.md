# genomes-pipeline

## Pipeline structure

#### First part **wf-1.cwl**

    1.1) checkm \
    1.2) checkm2csv \
    1.3) dRep \

    1.4.1) GTDB-Tk  \

    1.4.2) split_drep.py \
    1.5) classify_folders.py \

    2) taxcheck  \

output: 
 - checkm_csv
 - gtdbtk folder
 - taxcheck_dirs \
**plus folders for the next step**
 - one_genome (list of clusters/folders that have only one genome)
 - many_genomes (list of clusters/folders that have more than one genome)
 - mash_folder (list of mash-files from "many_genomes" clusters)

#### Second part
Check \
======> if many_genomes and one_genome presented: **run wf-exit-1.cwl**

        **2.1. For many_genomes part**
            
            1) Prokka
            2) Roary
            3) translate from fa to faa
            4.1) IPS
            4.2) EggNOG
            
        output: OUTPUT_MANY
         - mash_trees
         - cluster folder(-s)
         - prokka concatenated faa result
         
         
        **2.2. For one_genome part** 
        
            1) Prokka
            2.1) IPS
            2.2) EggNOG
            
        output: OUTPUT_ONE
         - cluster folder(-s)
         - prokka concatenated faa result

        **2.3. Final part**   
        
            1) cat prokka from many and one
            2) mmseqs 
        output: OUTPUT_3
         - mmseqs folder
    
======> if many_genomes presented BUT one_genome NOT presented: **run wf-exit-2.cwl**    
Step 2.1 + 2.3

======> if many_genomes NOT presented BUT one_genome presented: **run wf-exit-3.cwl**    
Step 2.2 + 2.3

#### Finally
Copy all outputs to one result folder


## How to run

1) Add path to folder with your genomes to YML file: workflows/yml_patterns/wf-1.yml
2) Run first workflow with: \
cwl: workflows/wf-1.cwl \
yml: workflows/yml_patterns/wf-1.yml (already changed to your data) \
Save output json to separate file. Example \
`cwltool workflows/wf-1.cwl workflows/yml_patterns/wf-1.yml > output-wf-1.json`
3) Run parser of output json \
`python3 workflows/parser_yml.py -j output-wf-1.json -y workflows/yml_patterns/wf-2.yml`
4) Check exit code of parser \
`echo $?` \
5*) If you want you can manually change limits for mmseqs_wf in workflows/yml_patterns/wf-2.yml \
5) If exit code == 1: run 
`cwltool workflows/wf-exit-1.cwl workflows/yml_patterns/wf-2.yml` \
If exit code == 2: run 
`cwltool workflows/wf-exit-2.cwl workflows/yml_patterns/wf-2.yml` \
If exit code == 3: run 
`cwltool workflows/wf-exit-3.cwl workflows/yml_patterns/wf-2.yml`
