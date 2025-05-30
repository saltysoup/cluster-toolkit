# Blueprint
ronin-slurm.yaml

# how to deploy
## generate terraform files only into a local directory with deployment_name
./gcluster create ronin-slurm.yaml -w

## deploy all resources silently
./gcluster deploy ronin-slurm.yaml -w --auto-approve

## deploy all resources silently using local tf files
./gcluster deploy ronin-slurm -w --auto-approve

## deploy using terraform
terraform -chdir=ronin-slurm/networkanddata init
terraform -chdir=ronin-slurm/networkanddata plan
terraform -chdir=ronin-slurm/networkanddata deploy
terraform -chdir=ronin-slurm/software init
terraform -chdir=ronin-slurm/software plan
terraform -chdir=ronin-slurm/software deploy

## changing number of login nodes
1. Update value to `slurm_login_node_count: 2` in blueprint yaml
2. Use above gcluster/tf deploy command
3. Terraform will run diff and deploy the changing infra only (additional slurm node)
4. New login node will connect to slurm cluster

## how to modify blueprint and update cloud resources
Best practice is to delete the impacted group/s, update the yaml and run gcluster deploy again. This is to avoid terraform complaining about different checksum of changing scripts stored in GCS

## destroy resources one group at a time
./gcluster destroy ronin-slurm # and delete/skip/stop when prompted
terraform -chdir=ronin-slurm/cluster destroy


## destroy all resources silently
./gcluster destroy ronin-slurm --auto-approve # destroys using local tf files, not blueprint yaml (create/update only)
