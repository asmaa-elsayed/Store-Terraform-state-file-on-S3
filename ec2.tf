terraform {
  backend "s3" {
    bucket   = "asmaa-bucket"
    key      = "asmaa/terraform.tfstate"
    region   = "us-west-1"
  }

}

provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "web" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = aws_key_pair.deployer1.key_name
  vpc_security_group_ids = [aws_security_group.allow_tls1.id]

  tags = {
    Name = var.ec2_tag
  } 
}

resource "aws_s3_bucket" "b" {
  bucket = var.bucket_name
  tags = {
    Name        = var.bucket_tag
  }
}

resource "aws_key_pair" "deployer1" {
  key_name   = var.key_name
  public_key = file(var.public_key)
}

resource "aws_security_group" "allow_tls1" {
  name        = "allow_tls1"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }



  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.sg_tag
  }
}

