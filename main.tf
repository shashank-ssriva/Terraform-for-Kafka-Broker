terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "ap-south-1"
}

resource "aws_security_group" "ssh_access" {
  name = "ssh_access"
  description = "SSH access to EC2 nodes"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }    
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "kafka_broker" {
  ami           = "ami-041d6256ed0f2061c"
  instance_type = "t2.micro"
  key_name      = "kafka_ssh_key"
  vpc_security_group_ids  = ["${aws_security_group.ssh_access.id}"]
  tags = {
    Name = "KafkaBroker"
  }
}

output "ssh_security_group_id" {
  value = aws_security_group.ssh_access.id
}

output "broker_instance_public_ip" {
  value = aws_instance.kafka_broker.public_ip
}

output "broker_instance_login" {
  value = "ssh ec2-user@${aws_instance.kafka_broker.public_ip} -i kafka_ssh_key.pem"
}
