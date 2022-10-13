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
