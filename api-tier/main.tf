module "catalogue" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "catalogue"

  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-0cd5626364cf1e071"] #replace your SG
  subnet_id = "subnet-0ff7989885902f665" #replace your Subnet
  ami = data.aws_ami.ami_info.id
  user_data = file("01-catalogue.sh")
  tags = {
    Name = "catalogue"
  }
}

module "user" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "user"

  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-0cd5626364cf1e071"] #replace your SG
  subnet_id = "subnet-0ff7989885902f665" #replace your Subnet
  ami = data.aws_ami.ami_info.id
  user_data = file("02-user.sh")
  tags = {
    Name = "user"
  }
}

module "cart" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "cart"

  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-0cd5626364cf1e071"] #replace your SG
  subnet_id = "subnet-0ff7989885902f665" #replace your Subnet
  ami = data.aws_ami.ami_info.id
  user_data = file("03-cart.sh")
  tags = {
    Name = "cart"
  }
}

module "shipping" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "shipping"

  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-0cd5626364cf1e071"] #replace your SG
  subnet_id = "subnet-0ff7989885902f665" #replace your Subnet
  ami = data.aws_ami.ami_info.id
  user_data = file("04-shipping.sh")
  tags = {
    Name = "shipping"
  }
}

module "payment" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "payment"

  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-0cd5626364cf1e071"] #replace your SG
  subnet_id = "subnet-0ff7989885902f665" #replace your Subnet
  ami = data.aws_ami.ami_info.id
  user_data = file("05-payment.sh")
  tags = {
    Name = "payment"
  }
}

module "dispatch" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "dispatch"

  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-0cd5626364cf1e071"] #replace your SG
  subnet_id = "subnet-0ff7989885902f665" #replace your Subnet
  ami = data.aws_ami.ami_info.id
  user_data = file("06-dispatch")
  tags = {
    Name = "dispatch"
  }
}


module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "catalogue"
      type    = "A"
      ttl     = 1
      records = [
        module.catalogue.private_ip
      ]
    },
    {
      name    = "user"
      type    = "A"
      ttl     = 1
      records = [
        module.user.private_ip
      ]
    },
    {
      name    = "cart"
      type    = "A"
      ttl     = 1
      records = [
        module.cart.private_ip
      ]
    },
    {
      name    = "shipping"
      type    = "A"
      ttl     = 1
      records = [
        module.shipping.private_ip
      ]
    },
    {
      name    = "payment"
      type    = "A"
      ttl     = 1
      records = [
        module.payment.private_ip
      ]
    },
    {
      name    = "dispatch"
      type    = "A"
      ttl     = 1
      records = [
        module.dispatch.private_ip
      ]
    }
  ]
}