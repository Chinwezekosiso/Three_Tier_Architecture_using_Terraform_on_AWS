# Web Server 1 - Public Subnet 1
resource "aws_instance" "Three_Tier_Arch_web1_ec2_instance" {
  ami           = "ami-0faea58d4f6a5b206" # Amazon Linux 2 (Update if needed for your region)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.Three_Tier_Arch_Public_Sub1.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.Three_Tier_Arch_web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install httpd -y
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "<h1>Welcome to the Web Server 1</h1>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "Three_Tier_Arch_web1_ec2_instance"
  }
}

# Web Server 2 - Public Subnet 2
resource "aws_instance" "Three_Tier_Arch_web2_ec2_instance" {
  ami           = "ami-0faea58d4f6a5b206"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.Three_Tier_Arch_Public_Sub2.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.Three_Tier_Arch_web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install httpd -y
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "<h1>Welcome to the Web Server 2</h1>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "Three_Tier_Arch_web2_ec2_instance"
  }
}

# Database Server - Private Subnet
resource "aws_instance" "Three_Tier_Arch_dbserver_ec2_instance" {
  ami           = "ami-0faea58d4f6a5b206"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.Three_Tier_Arch_Private_Sub.id
  vpc_security_group_ids = [aws_security_group.Three_Tier_Arch_db_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install mysql-server -y
              sudo systemctl start mysqld
              sudo systemctl enable mysqld
              EOF

  tags = {
    Name = "Three_Tier_Arch_dbserver_ec2_instance"
  }
}


# HTTP access from anywhere (for web servers)
resource "aws_security_group" "Three_Tier_Arch_web_sg" {
  name        = "Three_Tier_Arch_web_sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.Three_Tier_Arch_VPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# MySQL access from web servers only
resource "aws_security_group" "Three_Tier_Arch_db_sg" {
  name        = "Three_Tier_Arch_db_sg"
  description = "Allow MySQL from web servers"
  vpc_id      = aws_vpc.Three_Tier_Arch_VPC.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.Three_Tier_Arch_web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
