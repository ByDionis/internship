
#-------------------------
provider "aws" {
        access_key = var.access_key
        secret_key = var.secret_key
        region = var.region
        }

#---------------------------------------------------
# Create VPC
#---------------------------------------------------
resource "aws_vpc" "aws_vpc" {
    cidr_block                          = "${var.vpc_cidr}"
    instance_tenancy                    = "default"
    enable_dns_support                  = "true"
    enable_dns_hostnames                = "true"
    assign_generated_ipv6_cidr_block    = "false"
    enable_classiclink                  = "false"
    tags {
        Name            = "my-vpc"
    }
}


#------------------------
#Install Ubuntu
#------------------------
resource "aws_instance" "ubuntu_task3" {
ami = "ami-0d527b8c289b4af7f"
instance_type = var.instance_type
tags = {
    Name = "ubuntu_task3"
  }

  vpc_security_group_ids = [aws_security_group.security_group_for_Ubuntu.id]
  user_data = <<EOF
#!/bin/bash

#---------------------------
Install apache and create web page
#---------------------------
yum -y update
yum - y install httpd
echo "Hello World" > /var/www/html/index.html
lsb_release -a > /var/www/html/index.html
service httpd start
chkconfig httpd on

#---------------------------
Docker to Ubuntu
#---------------------------
#Первым делом обновите существующий список пакетов:
sudo apt update

#Затем установите несколько необходимых пакетов, которые позволяют apt использовать пакеты через HTTPS:
sudo apt install apt-transport-https ca-certificates curl software-properties-common

#Добавьте ключ GPG для официального репозитория Docker в вашу систему:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#Добавьте репозиторий Docker в источники APT:
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

#Потом обновите базу данных пакетов и добавьте в нее пакеты Docker из недавно добавленного репозитория:
sudo apt update

#Установите Docker:
sudo apt install docker-ce


EOF

}

#------------------------
#Install CentOS
#------------------------

resource "aws_instance" "CentOS" {
ami = "ami-06ec8443c2a35b0ba"
instance_type = var.instance_type
tags = {
    Name = "CentOS_task3"
        }
vpc_security_group_ids = [aws_security_group.Security_group_for_CentOS.id]
}

#---------------------------
resource "aws_security_group" "security_group_for_Ubuntu" {
name = "security group for Ubuntu"
description  = "security group 1"

ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "ssh"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
}

egress {
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]
  prefix_list_ids = ["pl-12c4e678"]
}
}

#-----------------------------------
resource "aws_security_group" "Security_group_for_CentOS" {
name = "Security group for CentOS"
description  = "security group 2"

ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "ssh"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  from_port   = 443
  to_port     = 443
  protocol    = "HTTPS "
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
}

egress {
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]
  prefix_list_ids = ["pl-12c4e678"]
}
}
