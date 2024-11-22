data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "web-server"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = ["10.10.0.0/16"]
}


module "ec2_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "single-instance"
  ami                    = data.aws_ami.ubuntu.id
  user_data              = file("user-data.sh")
  instance_type          = "t2.micro"
  key_name               = "temporal"
  monitoring             = true
  vpc_security_group_ids = [module.web_server_sg.security_group_id]
  #subnet_id              = "subnet-eddcdzz4"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}