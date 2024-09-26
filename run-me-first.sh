#!/bin/bash

# Variables
project_id="johnydev"
service_account_email="terraform-sa@${project_id}.iam.gserviceaccount.com"
key_ids=$(gcloud iam service-accounts keys list --iam-account=$service_account_email --format="value(name)")
filename="gcp-credentials.json"
# End Variables

# update helm repos
helm repo update

# Google cloud authentication
echo "--------------------GCP Login--------------------"
gcloud auth login

# Check if there are any keys to delete
if [ -z "$key_ids" ]; then
    echo "No keys found for service account: $service_account_email"
    exit 0
fi

# Loop through each key ID and delete the key
for key_id in $key_ids; do
    echo "Deleting key $key_id for service account: $service_account_email"
    gcloud iam service-accounts keys delete $key_id --iam-account=$service_account_email --quiet
done

# Get GCP credentials
echo "--------------------Get Credentials--------------------"
gcloud iam service-accounts keys create modules/${filename} --iam-account ${service_account_email}