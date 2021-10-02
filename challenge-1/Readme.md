# challenge 1

part 1 : 

    kpm.png is the high level architecture of the solution whihc we will deply for serving 3 -tier application.

part 2 : 

    1. Terraform folder containes script to create the resource and do the deployment.
    2. This tf script will create basic resources in "AWS"  not all the resource like it will not create route table ,and its association, some SG group, and this script can also be written using modules

    terraform version :0.14.0

steps to run terrform script :

    1. tfswitch :  Downloads the required terraform version. Make sure you have tfswitch installed else download tf version : 0.14.0

    2. terraform init  :  To initialize the terraform 

    3. terraform plan  : To see the resiurce planing wihcih will get created

    4. terraform apply  :  To create terraform resoures in AWS.