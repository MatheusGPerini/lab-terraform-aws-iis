# lab-terraform-aws-iis
That lab is for who need a first step to understand about terraform and the integration with aws resources, in that lab we made a high diponibility infrastructure with EC2 + LB + ASG.
The website display the ip of the server where it runing.

#### Pre-req:

* Terraform v0.11
* Account on AWS


## Steps

**Obs: Set up aws account on your local machine, need the secret_access_key and access_key_id.**

First we need to create a bucket on S3, in that lab i call it lab-terraform-iis-tfstate, you can put whatever name, just remember to change on main.tf.

Second, clone that project and run the commands:

* terraform init
* terraform plan -var-file=environments/lab.tfvars (This is to see what will be create)
* terraform apply -var-file=enviroments/lab.tfvars


