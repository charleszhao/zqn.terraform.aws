# Summary
The first part of this example will use GitHub as the code repo, and Terraform Cloud to provision AWS EC2 instance.
The second part of this example will use Azure DevOps to host the code, and build the pipeline to provision AWS EC2 instance.

# 1. Prerequisite - AWS user
1.1 Create a user group, give a name of your user group, and attach "AmazonEC2FullAccess" permission to this user group:
![image](https://user-images.githubusercontent.com/2050620/195009400-2734173c-38c5-45cf-8ca0-e2629112e278.png)

1.2 Create a user, give a user name and tick "Access key - Programmatic access":
![image](https://user-images.githubusercontent.com/2050620/195009634-06a8362b-e41e-4269-b911-7f78973d0547.png)

1.3 Select the user group we just created:
![image](https://user-images.githubusercontent.com/2050620/195009798-a2ebf759-aff2-43d0-bcb5-171c1dcbe73a.png)

After the user being created, download the user credential csv file, it will contains the credentials for later use.

# 2. Part 1
## 2.1 GitHub
### 2.1.1 Create a new repo
### 2.1.2 Create a new instance tf file in the repo
ec2.tf
``` terraform
provider "aws" {
  region = "ap-southeast-1"
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_ACCESS_KEY
}
resource "aws_instance" "charles_ec2_terraform" {
  ami = "ami-065859ffdc7cf9882"
  instance_type = "t3.micro"
}
```
### 2.1.3 Create a new variable tf file
vars.tf
``` terraform
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_ACCESS_KEY" {}
```
The file structure will be like this:
![image](https://user-images.githubusercontent.com/2050620/195010969-84a396e1-9913-4a8f-a42b-bae520367dd3.png)

We are going to configure these two variable values in Terraform Cloud later, the value will refering to the user credentials in step 1.2.

## 2.2 Terraform Cloud
### 2.2.1 Sign up
https://app.terraform.io/app

### 2.2.2 Create Organization
![image](https://user-images.githubusercontent.com/2050620/195007023-4e20660a-1a78-4ce3-b208-fa846fc48ebf.png)

### 2.2.3 Create Workspace
Choose "Version control workflow":
![image](https://user-images.githubusercontent.com/2050620/195007164-978c1be2-7975-4d96-bbe8-4910c109492f.png)

Choose "GitHub" or other VCS, this requires to login to the VCS:
![image](https://user-images.githubusercontent.com/2050620/195007917-474ecf5d-b2b0-4898-a480-a7b2d7922ebf.png)

After connect to your VCS, select the repo we created in Step 2.1

Name your workspace and click "Create workspace" button:
![image](https://user-images.githubusercontent.com/2050620/195011821-8ca909c7-a4aa-464b-a593-24e7856b3b31.png)

### 2.2.4 Config variables
Go to Settings:
![image](https://user-images.githubusercontent.com/2050620/195012060-be280a20-dfa3-4912-af24-04f6bb61df5e.png)

Select Variable sets, and click "Create variable set":
![image](https://user-images.githubusercontent.com/2050620/195012238-20b39fd7-7cb1-457d-80cb-d92eef717b92.png)

Give a name and add variable values:
![image](https://user-images.githubusercontent.com/2050620/195012337-3b21e452-9080-43fa-9994-29395e4ee4c1.png)

In this example, we have two variables in the vars.tf, so here we are going to config two variables:
![image](https://user-images.githubusercontent.com/2050620/195012653-91637081-6c12-4743-93cc-275db8dfa451.png)

The two values you should copy from the user credential csv file:
![image](https://user-images.githubusercontent.com/2050620/195012986-566d32db-2718-4f6d-b822-7f334dd83535.png)

## 2.3 Trigger the Plan from Terraform Cloud UI
Select "Start new run":
![image](https://user-images.githubusercontent.com/2050620/195015211-81b0f0d8-67f1-47f7-bb07-406a477ee463.png)

Confirm to run the plan, and you can see the status:
![image](https://user-images.githubusercontent.com/2050620/195476941-e345824e-be2f-4660-b439-f5d66effe0ec.png)

After the plan completed, you can see the new EC2 instance in the AWS console:
![image](https://user-images.githubusercontent.com/2050620/195476531-9d243e95-d2d6-458c-a234-08f070790c88.png)

## 2.4 Terminate the resources
Go to Settings/Destruction and Deletion, click "Queue destroy plan":
![image](https://user-images.githubusercontent.com/2050620/195016166-f1ec9291-d51a-43cd-a940-faf736f18051.png)

Confirm by enter the namespace name:
![image](https://user-images.githubusercontent.com/2050620/195016376-7d97d8c5-cbb4-4626-8277-1763f65646f7.png)

Click "Confirm & Apply":
![image](https://user-images.githubusercontent.com/2050620/195016673-ddb2ee65-1eed-4721-803f-c0765d3cccb1.png)

You can see the apply finished: 
![image](https://user-images.githubusercontent.com/2050620/195017239-2c95c55c-43d5-4c56-af6d-b5ceaf9eb3c3.png)

# 3. Part 2
## 3.1 Create a new project in Azure DevOps
![image](https://user-images.githubusercontent.com/2050620/195291468-ca1db847-fd81-418d-a156-a91acdc7016e.png)

## 3.2 Clone the repo from GitHub
![image](https://user-images.githubusercontent.com/2050620/195291705-1f5b54da-3058-4cc3-a167-9b346119a767.png)

## 3.3 Create build pipeline
Click 'New pipeline' button:
![image](https://user-images.githubusercontent.com/2050620/195292023-de1534e5-e0ee-4461-9288-f60cbed30756.png)

Select 'Use the classic editor to create a pipeline without YAML':
![image](https://user-images.githubusercontent.com/2050620/195292191-124f9ad3-3951-449f-bad8-d9439d10c0dd.png)

Select the project and repo, and click 'Continue':
![image](https://user-images.githubusercontent.com/2050620/195292379-7b7324c6-e526-40c9-b1e2-ef35e57193a4.png)

Select 'Empty job' for the template:
![image](https://user-images.githubusercontent.com/2050620/195292511-2d7221be-a279-488e-8bbd-3c92eae2a608.png)

Give a name to your pipeline:
![image](https://user-images.githubusercontent.com/2050620/195292681-3f207607-2642-4503-9b45-7d2588804551.png)

Click the '+' sign beside the 'Agent job 1', search 'copy file', and click Add:
![image](https://user-images.githubusercontent.com/2050620/195293094-78d21fb6-077d-4530-b7c9-a593d0123d29.png)

Change the 'Target Folder' to ```$(Build.ArtifactStagingDirectory)/Terraform```:
![image](https://user-images.githubusercontent.com/2050620/195293375-059130f2-16b4-4fc3-b5dd-9cbe950bfc27.png)

Add another task 'Publish build artifacts':
![image](https://user-images.githubusercontent.com/2050620/195293901-fa99f42b-5cc3-40fe-b308-856d3f9f26fb.png)

Keep the default value and save the pipeline:
![image](https://user-images.githubusercontent.com/2050620/195294203-67a1e4ab-c1a5-45ab-bbed-7f2923023a81.png)

## 3.4 Create a new service connection
Go to project settings, then click 'New service connection':
![image](https://user-images.githubusercontent.com/2050620/195303266-db67d494-afda-4d51-a8b6-84df0ae34114.png)

Select 'AWS for Terraform' then click 'Next':
![image](https://user-images.githubusercontent.com/2050620/195303845-91019166-8eb2-42fd-a38b-daf9f9d5b68b.png)

Provide the access key and secret access key (same as Step-1), and key in the region, click 'Save':
![image](https://user-images.githubusercontent.com/2050620/195304420-7d428eb1-12fa-4f78-969a-1bef99d66208.png)


## 3.5 Create release pipeline
Click 'New' and 'New release pipeline':
![image](https://user-images.githubusercontent.com/2050620/195296408-4b908a0e-c9c1-4a4c-a613-aaeb37c51a20.png)

Click 'Empty job' as the emplate:
![image](https://user-images.githubusercontent.com/2050620/195304858-c7b8d0b9-9923-447f-82b5-40cd535fe87f.png)

Click 'Add an artifact' and select our build pipeline as the source:
![image](https://user-images.githubusercontent.com/2050620/195305049-5c3de733-0784-4fb8-a200-39f561764da6.png)

Click 'Tasks':
![image](https://user-images.githubusercontent.com/2050620/195305295-a7905827-4b0c-45b3-9453-c6a4487b461a.png)

Add new job 'Terraform tool installer':
![image](https://user-images.githubusercontent.com/2050620/195305485-3dae7489-116a-48a2-a1be-d6168e9c2780.png)

Keep the default value:
![image](https://user-images.githubusercontent.com/2050620/195305849-dc5b389c-ad1b-4e20-9cc2-b5d2817dd271.png)

Add new job 'Terraform':
![image](https://user-images.githubusercontent.com/2050620/195305960-d8e84572-d617-4bb8-b46a-889b5b918d71.png)

Configure the job as Terraform init:
- 'Provider' to 'aws'
- 'Display name' to 'Terraform : aws init'
- under 'Amazon Web Services connection' select the new service connection we created in step-3.4
- give a S3 bucket name which you created in AWS
- give the key value 'tf/terraform.tfstate'
![image](https://user-images.githubusercontent.com/2050620/195308843-3a777dc1-28a9-4131-ac26-6bedb0daf0fd.png)

Add another 'Terraform' job and configrue it as Terraform plan:
- 'Provider' to 'aws'
- 'Display name' to 'Terraform : aws plan'
- 'Command' to 'plan'
- under 'Amazon Web Services connection' select the new service connection we created in step-3.4
![image](https://user-images.githubusercontent.com/2050620/195312405-6f52e3f9-66ac-440c-abb6-b2a1c6b2dc09.png)

Add another 'Terraform' job and configrue it as Terraform apply:
- 'Provider' to 'aws'
- 'Display name' to 'Terraform : aws apply'
- 'Command' to 'apply'
- under 'Amazon Web Services connection' select the new service connection we created in step-3.4
![image](https://user-images.githubusercontent.com/2050620/195312684-1094b448-1758-46e8-a14f-22e7328edba4.png)

Go to variables, add these two variables:
- TF_VAR_AWS_ACCESS_KEY
- TF_VAR_AWS_SECRET_ACCESS_KEY
![image](https://user-images.githubusercontent.com/2050620/195475574-fdcf2090-9a13-4daf-8f93-cbd256adbb81.png)
The values are the same as in Step-1

As you can see, the variable name in vars.tf is different from the variable name in the pipeline, this is because if we define Azure DevOps pipeline variables with a prefix of ```TF_VAR_```, they will get mapped into environment variables that Terrfaorm will pick them up. Azure DevOps will always transform pipeline variables to uppercase environment variables, so we have to define the variables with capital letters in Terraform configuration.
Reference: [Terraform input variables using Azure DevOps](https://gaunacode.com/terraform-input-variables-using-azure-devops)

# 4. Enhancement
## 4.1 More configurations in ec2.tf
```Terraform
provider "aws" {
  region = "ap-southeast-1"
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_ACCESS_KEY
}
resource "aws_instance" "charles_ec2_from_terraform" {
  ami = "ami-065859ffdc7cf9882"
  instance_type = "t3.micro"
  tags = {
    Name = "charles_ec2_from_terraform"
    Environment = var.ENVIRONMENT
    OS = "Windows"
    Project-Code = "Demo"
  }
  key_name = var.KEY_PAIR
  subnet_id = var.SUBNET_ID
  vpc_security_group_ids = [var.VPC_SECURITY_GROUP_IDS]
  iam_instance_profile = var.IAM_INSTANCE_PROFILE//this will require iam:PassRole permission
}
```
Three things need to highligh here:
1) You see the square brackets in ```vpc_security_group_ids```? This is because the configuration requies a set of string
2) In order to set the ```iam_instance_profile```, AWS user we are using must have ```iam:PassRole``` permission, we are going to add this permission in Step-4.3
3) Here we assigned the key-pair value, you need to create a key pair first, then assgin the value here

## 4.2 More variables in vars.tf
```Terraform
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_ACCESS_KEY" {}
variable "ENVIRONMENT" {}
variable "IAM_INSTANCE_PROFILE" {}
variable "KEY_PAIR" {}
variable "SUBNET_ID" {}
variable "VPC_SECURITY_GROUP_IDS" {}
```

## 4.3 Add ```iam:PassRole``` permission
As mentioned in Step-4.1, we need to have this permission when creating EC2 instance through Terraform. Go to the user group we created before in AWS console, click "Add permissions/Create inline policy":
![image](https://user-images.githubusercontent.com/2050620/195566737-cf828e8a-6f03-4b04-b730-54c6c20c73cd.png)

Search and choose "IAM" for the service:
![image](https://user-images.githubusercontent.com/2050620/195567094-135201d6-2fd6-46b8-b1c4-3b960d714942.png)

Filter and select "PassRole" for the actions:
![image](https://user-images.githubusercontent.com/2050620/195567301-048e183e-11b0-4690-a898-2b3cbeba6ae2.png)

Select "All resources" for the resources:
![image](https://user-images.githubusercontent.com/2050620/195567446-b28277c1-8dcf-429b-918c-c4049099abab.png)

Click "Specify request conditions", then click "Add condition":
![image](https://user-images.githubusercontent.com/2050620/195567592-8914e02f-6262-44e2-9dd8-440b9776df37.png)

Select the following in the popup:
- Condition key: iam:PassedToService
- Operator: StringEquals
- Value: ec2.amazonaws.com
![image](https://user-images.githubusercontent.com/2050620/195568037-9e12e0e6-c9b8-4c70-bb75-9d8d861c57f7.png)

After click "Add" it will returen to the create policy page, click "Review policy" at the bottom:
![image](https://user-images.githubusercontent.com/2050620/195568277-1e8962aa-0a26-4530-bff3-90f3cc630b09.png)

Give a name to the policy and click "Create policy":
![image](https://user-images.githubusercontent.com/2050620/195568591-259c4a02-ea00-495c-a206-5c2ff2f20d4a.png)

Now we have the new policy under the user group permissions:
![image](https://user-images.githubusercontent.com/2050620/195568721-a56236b4-d968-4c4a-9df6-1b277895b98a.png)

## 4.4 Create variable group in Azure DevOps
Go to Libray and click add variable group, give a name and add the following variables:
![image](https://user-images.githubusercontent.com/2050620/195569725-399d2db5-3404-4128-91b3-88ee9dbc41af.png)

## 4.5 Update release pipeline to use this variable group
Go to the release pipeline, and select "Variables"/"Variable groups", then select "Link variable group":
![image](https://user-images.githubusercontent.com/2050620/195570337-28cce757-2f57-48b4-b927-401a6bdf1db2.png)

Select the variable group created jsut now, and select the stage, then click "Link":
![image](https://user-images.githubusercontent.com/2050620/195570526-3cbc45fc-5627-4b65-a81b-b7856bce733d.png)

Now we have all the variables:
![image](https://user-images.githubusercontent.com/2050620/195570750-0d2374e8-607f-4225-b178-adadca9a5ab8.png)

Delete all pipeline variables, becasue we are going to use the variable group:
![image](https://user-images.githubusercontent.com/2050620/195570971-ecd50617-5ffd-4eb7-b330-e9eb1d6ff272.png)

click "Save" to save the pipline changes.

Now you can run the pipeline again.

After the EC2 instance being created, we can login to the VM by using the key-pair we configured.

Select Connect in the EC2 instance:
![image](https://user-images.githubusercontent.com/2050620/195571992-d8ee5543-d733-494c-91b2-0a82c91bfe27.png)

Click "RDP client" then "Connect using Fleet Manager", then "Fleet Manager Remote Desktop":
![image](https://user-images.githubusercontent.com/2050620/195572463-10a0fcc6-c57e-4098-bd7e-2fc304f09509.png)

It will open another browser tab, select "Key pair", the click "Browser", select the key pair download before and click "Open":
![image](https://user-images.githubusercontent.com/2050620/195572838-13d18cdd-2138-4f12-9305-4c901add293b.png)

Now click "Connect":
![image](https://user-images.githubusercontent.com/2050620/195573098-0272483c-6232-4199-ab25-99161a6127b9.png)

Now you can access your windows VM from the browser:
![image](https://user-images.githubusercontent.com/2050620/195573239-431c439b-04fe-42c1-a89d-b704a71656a2.png)





