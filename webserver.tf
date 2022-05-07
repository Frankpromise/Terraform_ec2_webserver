#choose the aws region to host your instance

provider "aws" {
    region = "us-east-1"
}

#create an aws security group that will allow ssh and http
resource "aws_security_group"  "allow-ssh-http" {
    name = "allow-ssh-http"
    description = "A security group that allows ssh and http traffic from anywhere"
    
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = 80
        to_port = 80
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


#Create ec2_instance

resource "aws_instance" "my_web_server" {
    ami = "ami-099bc67a2500003c1"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    security_groups = ["${aws_security_group.allow-ssh-http.name}"]
    key_name = "my_web"
    user_data = <<-EOF
                    #!/bin/bash
                    sudo apt install httpd
                    sudo systemctl start httpd
                    sudo systemctl enable httpd
                    echo "<h1>Sample Webserver Network Nuts" | sudo tee  /home/573855.cloudwaysapps.com/hfjzxghgzg/public_html/html/index.html
  EOF
  
  tags = {
      Name = "my_web_server"
  }
}