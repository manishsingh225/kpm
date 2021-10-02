resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/24"
  
  tags = {
    Name        = "KPMG",
    }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "igw-kpmg",
  }
}


resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.100.0.0/28"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name             = "public-kpmg"
    }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.100.1.0/28"
  availability_zone = "ap-south-1a"
  
  tags = {
    Name             = "private-kpmg"
  }
}


resource "aws_eip" "nat_eip" {

  vpc = true
  tags = {
    Name        = "kpmg-nat-eip"
  }
}


resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name        = "kpmg"
  }
}

#SG

resource "aws_security_group" "kpmg-sg" {
  name        = "kpmg-sg"
  vpc_id      = aws_vpc.main.id
  
  
  tags = {
    Name        = "kpmg-sg"
  }
}

resource "aws_security_group_rule" "http_ingress" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.kpmg-sg.id
}


resource "aws_security_group_rule" "ssh_ingress" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.kpmg-sg.id
}

resource "aws_security_group_rule" "kpmg_all_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.kpmg-sg.id
}


# EC2 

resource "aws_instance" "main_pubic" {

  ami                         = "ami-0a23ccb2cdd9286bb"
  instance_type               = "t2.micro"
  key_name                    = "kpmg-key"
  vpc_security_group_ids      = [aws_security_group.kpmg-sg.id]
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = "true"
  
  depends_on = [aws_vpc.main,aws_subnet.public]
  tags = {
    Name        = "kpmg-instance-public"
  }
}


resource "aws_eip" "ip" {
  instance = aws_instance.main_pubic.id
  vpc      = true
  tags = {
    Name        = "kpmg-eip-ec2"
  }
}


resource "aws_instance" "main_private" {

  ami                         = "ami-0a23ccb2cdd9286bb"
  instance_type               = "t2.micro"
  key_name                    = "kpmg-key"
  vpc_security_group_ids      = [aws_security_group.kpmg-sg.id]
  subnet_id                   = aws_subnet.private.id
  associate_public_ip_address = "false"
  
  depends_on = [aws_vpc.main,aws_subnet.public]
  tags = {
    Name        = "kpmg-instance-private"
  }
}