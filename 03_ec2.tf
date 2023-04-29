data "aws_ssm_parameter" "this" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"

}

resource "aws_security_group" "my-poc-security-group" {
  vpc_id = data.aws_vpc.poc-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
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
resource "aws_instance" "poc-instance" {
  ami             = data.aws_ssm_parameter.this.value
  subnet_id       = data.aws_subnet.poc-vpc-public-us-east-1a.id
  instance_type   = "t2.medium"
  tags            = { Name = "poc-instance" }
  user_data       = <<-EOF
        #!/bin/bash
        echo "*** Installing apache2"
        sudo yum update -y
        sudo yum install -y httpd
        sudo systemctl start httpd.service
        sudo systemctl enable httpd.service
        echo "*** Completed Installing apache2"
    EOF
  security_groups = [aws_security_group.my-poc-security-group.id]


}
