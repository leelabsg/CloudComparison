# Log in and initialize Google Cloud
gcloud init 
gcloud auth login

# Create VM instance and run SAIGE
gcloud compute instances create dockertest2 \
    --machine-type=c2-standard-8 \
    --image=ubuntu-2204-jammy-v20230908 \
    --image-project=ubuntu-os-cloud \
    --boot-disk-size=20GB \
    --create-disk=size=500GB \
    --zone=us-central1-a \
    --metadata=startup-script-url=gs://leelabsg-cloud-test/UKBB/startup_script_test.sh

# Delete VM instance
gcloud compute instances delete dockertest2