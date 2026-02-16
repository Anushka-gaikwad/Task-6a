provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "strapi" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name      = "my-strapy-key-pair"
  vpc_security_group_ids = [aws_security_group.allow_http.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install docker -y
              systemctl start docker
              usermod -aG docker ec2-user

              docker pull anushka1104/strapi:${var.image_tag}
              docker run -d -p 80:1337 yourdockerhubusername/strapi:${var.image_tag}
              EOF

  tags = {
    Name = "Strapi-App"
  }
}

output "public_ip" {
  value = aws_instance.strapi.public_ip
}

