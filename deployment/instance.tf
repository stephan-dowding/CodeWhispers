data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  owners = ["amazon"]
}

data "aws_ip_ranges" "instance_connect" {
  regions  = [local.region]
  services = ["ec2_instance_connect"]
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"

  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.app.id]
  user_data                   = file("${path.module}/instance_user_data.sh")
  user_data_replace_on_change = true
  tags = {
    Name = "CodeWhispers"
  }
}

resource "aws_security_group" "app" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "App Traffic incoming"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = data.aws_ip_ranges.instance_connect.cidr_blocks
    description = "SSH Ingress from EC2 instance connect"
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP outgoing (for initial install)"
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS outgoing (for initial install)"
  }
}