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
resource "aws_instance" "kafka_broker" {
  ami           = "ami-041d6256ed0f2061c"
  instance_type = "t2.micro"
  key_name      = "kafka_ssh_key"
  vpc_security_group_ids  = ["sg-07a21c279021a0df2"]
  tags = {
    Name = "KafkaBroker"
  }
}

output "broker_instance_public_ip" {
  value = aws_instance.kafka_broker.public_ip
}

output "broker_instance_login" {
  value = "ssh ec2-user@${aws_instance.kafka_broker.public_ip} -i kafka_ssh_key.pem"
}
