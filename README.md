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

## 3.4 Create release pipeline
Click 'New' and 'New release pipeline':
![image](https://user-images.githubusercontent.com/2050620/195296408-4b908a0e-c9c1-4a4c-a613-aaeb37c51a20.png)




