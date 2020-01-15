# On Building

# lab-terraform-aws-iis
This lab is for those who need a first step in understanding terraform and integrating with aws features. In this lab we created a high availability infrastructure with EC2 + LB + ASG. The site displays the ip of the server it is running on.

#### Pre-req:

* Terraform v0.11
* Account on AWS


## Steps

**PS: Set up aws account on your local machine, need the secret_access_key and access_key_id.**

First, we need to create a bucket in S3; in this lab, I call lab-terraform-iis-tfstate; you can put any name, remember to change it in main.tf.

Second, in environments/lab.tfvars, there are two variables you need to change, vpc_id and subnets; if you created, put the IDs in related variables; otherwise enter the default subnet and vpc IDs.

In another project, I will show you how to create vpc and subnets and reuse them in other projects.

Third, clone that project and run the commands:

* terraform init
* terraform plan -var-file=environments/lab.tfvars (This is to see what will be create)
* terraform apply -var-file=enviroments/lab.tfvars



