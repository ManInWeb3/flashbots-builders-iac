# 

## Builder's private key to sign payment transaction
Must have the same name as builder Ec2 instance name, and is a plane text string



## How to
### Generate a new secret key for builder


### RSYNC data to an instance
rsync -arP -e "ssh -i Path_to_the_key.pem" SOURCe_DIR ubuntu@INSTANCE_IP:/DEST

# TODO
1. Rotate logs