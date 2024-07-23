module "web" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "web"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [var.sg_id] #replace your SG
  subnet_id = var.public_subnet_id #replace your Subnet
  ami = data.aws_ami.ami_info.id
  user_data = file("web.sh")
  tags = {
    Name = "web"
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "web"
      type    = "A"
      ttl     = 1
      records = [
        module.web.public_ip
      ]
    }
  ]
}