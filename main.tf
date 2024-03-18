resource "aws_vpc" "mtc_aws" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "mtc_public_subnet" {
  vpc_id                  = aws_vpc.mtc_aws.id
  cidr_block              = "10.123.1.0/24"
  availability_zone       = "${var.provider_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "dev_public"
  }
}

resource "aws_internet_gateway" "mtc_internet_gateway" {
  vpc_id = aws_vpc.mtc_aws.id

  tags = {
    Name = "dev_igw"
  }
}

resource "aws_route_table" "mtc_public_rt" {
  vpc_id = aws_vpc.mtc_aws.id

  tags = {
    Name = "dev_public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.mtc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mtc_internet_gateway.id
}

resource "aws_route_table_association" "mtc_public_assoc" {
  subnet_id      = aws_subnet.mtc_public_subnet.id
  route_table_id = aws_route_table.mtc_public_rt.id
}


resource "aws_security_group" "mtc_sg" {
  name        = "dev_sg"
  description = "Allow inbound traffic - dev"
  vpc_id      = aws_vpc.mtc_aws.id
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.mtc_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.mtc_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "ingress" {
  security_group_id = aws_security_group.mtc_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "-1"
  to_port     = 0
}

resource "aws_key_pair" "mtc_auth" {
  key_name   = "mtckey"
  public_key = file("${var.ssh_key_path}.pub")
}

resource "ansible_playbook" "playbook" {
  depends_on = [aws_instance.dev_node]
  playbook   = "nginx.yaml"
  name       = aws_instance.dev_node.public_ip
  replayable = true
}

resource "ansible_host" "my_ec2" { #### ansible host details
  depends_on = [aws_instance.dev_node]
  name       = aws_instance.dev_node.public_ip
  groups     = ["nginx"]
  variables = {
    ansible_user                 = "ubuntu",
    ansible_ssh_private_key_file = var.ssh_key_path,
    ansible_python_interpreter   = "/usr/bin/python3"
  }
}

resource "aws_instance" "dev_node" {
  instance_type          = var.instance_type
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.mtc_auth.key_name
  vpc_security_group_ids = [aws_security_group.mtc_sg.id]
  subnet_id              = aws_subnet.mtc_public_subnet.id

  tags = {
    Name = "dev_node"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.yml nginx.yaml"
  }
}
