#!/bin/bash

function pause(){
   read -p "$*"
}

read -p "What is the operating system? (windows or linux) " os

terraform plan -var-file=environments/lab.tfvars -var so=${os} -no-color -out=${TF_PLAN} -input=false >> ${TF_PLAN}.out

if [ "$?" -ne 0 ]
then
    echo "Error Terraform Plan"
    pause "Press any key to continue!!"
    exit
else
    echo "Plan worked!"
    pause "Press any key to continue!!"
fi

terraform apply "${TF_PLAN}" -no-color
if [ $? -eq 0 ]
then
	echo "Terraform successfully applied changes, ${TFPLAN} deployed."
    pause "Press any key to continue!!"
else
	echo "ERROR, Terraform failed, aborting..."
	pause "Press any key to continue!!"
    exit
fi