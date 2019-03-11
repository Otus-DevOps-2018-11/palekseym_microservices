#!/bin/sh
# used to pull the current state from S3 and
# use this information for provisioning
state_file_name="terraform.tfstate"

# fetch current state form s3
(cd ~/repo/palekseym_microservices/docker-monolith/infra/terraform/stage && terraform state pull) > ${state_file_name}
./terraform.py ${1} ${2}

rm ${state_file_name}
