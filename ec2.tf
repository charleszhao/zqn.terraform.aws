provider "aws" {
  region = "ap-southeast-1"
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_ACCESS_KEY
}
resource "aws_instance" "charles_ec2_terraform" {
  ami = "ami-065859ffdc7cf9882"
  instance_type = "t3.micro"
}
