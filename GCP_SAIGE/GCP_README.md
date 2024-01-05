This folder contains code necessary to run SAIGE in GCP. 

___Pre-Processing Steps___

1) Upload the phenotype file of choice to a GCP bucket (gs://leelabsg-clouud-test/UKBB/...)
2) Upload the necessary files for SAIGE:
   2.1) SAIGE Step 0, 1:
   UKB_step1.bim,
   UKB_step1.bed,
   UKB_step1.fam
   2.2) SAIGE Step 2: ukb45227_imp_chr1_v3_s487296.sample, ukb_imp_chr${chr}_v3.bgen, ukb_imp_chr${chr}_v3.bgen.bgi

___Running SAIGE on GCP___
1) Requires access to buckets (leelabsg-cloud-test)
2) Have to upload the start-up-script to the bucket
3) In order for the start-up script to run successfully, all necessary SAIGE files (for steps 0,1,2) need to be in the bucket in the corresponding folders.
4) By following the "GCP_Script" code, GCP will automatically create a bucket and start to run SAIGE.

____UPDATING SOON____
1) Error in transferring finished output files back to the bucket (Debugging)
