provider "aws" {
  region = "ap-south-1"
  access_key = "AKIAV2PWYSAXWBDJULYC"
  secret_key = "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"
}

data "aws_ami" "my_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ami-java-node-tomcat-build"]
  }
}

resource "aws_launch_configuration" "java-node" {
  name_prefix          = "packer"
  image_id             = data.aws_ami.my_ami.id 
  instance_type        = "t2.micro"  
  security_groups      = ["sg-08b8c487429a0e855"]  
  key_name             = "packer.keypair"  
  user_data            = "#!/bin/bash\necho Hello, World!"  
  associate_public_ip_address = true  

}

resource "aws_autoscaling_group" "java-node" {
  name_prefix                   = "java.node"
  launch_configuration          = aws_launch_configuration.java-node.name
  vpc_zone_identifier           = ["subnet-066d3c49c0d86c93a"] 
  min_size                      = 1  
  max_size                      = 2  
  desired_capacity              = 1  
  health_check_type             = "EC2" 
  health_check_grace_period     = 300 
  wait_for_capacity_timeout     = 0

}
