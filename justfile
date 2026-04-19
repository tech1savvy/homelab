set dotenv-load := true
set dotenv-override := true

export AWS_PROFILE := "tech1savvy"

[default]
init-plan-apply:
    just init
    just plan
    just apply

init:
    terraform -chdir=terraform init

plan:
    terraform -chdir=terraform plan -out=.tfplan

apply:
    terraform -chdir=terraform apply .tfplan

destroy:
    terraform -chdir=terraform destroy

output:
  terraform -chdir=terraform output

clean:
    rm -f terraform/tfplan
    rm -rf terraform/.terraform
    rm -f terraform/.terraform.lock.hcl

clean-state:
    rm -f terraform/terraform.tfstate terraform/terraform.tfstate.backup

state:
    terraform -chdir=terraform state list
