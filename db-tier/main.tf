module "mongodb" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "mongodb"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [var.sg_id] #replace your SG
  subnet_id = var.public_subnet_id #replace your Subnet
  ami = data.aws_ami.ami_info.id
  user_data = file("01-mongodb.sh")
  tags = {
    Name = "mongodb"
  }
}

module "redis" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "redis"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [var.sg_id] #replace your SG
  subnet_id = var.public_subnet_id #replace your Subnet
  ami = data.aws_ami.ami_info.id
  user_data = file("02-redis.sh")
  tags = {
    Name = "redis"
  }
}

module "mysql" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "mysql"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [var.sg_id] #replace your SG
  subnet_id = var.public_subnet_id #replace your Subnet
  ami = data.aws_ami.ami_info.id
  user_data = file("03-mysql.sh")
  tags = {
    Name = "mysql"
  }
}

module "rabbitmq" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "rabbitmq"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [var.sg_id] #replace your SG
  subnet_id = var.public_subnet_id #replace your Subnet
  ami = data.aws_ami.ami_info.id
  user_data = file("04-rabbitmq.sh")
  tags = {
    Name = "rabbitmq"
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "mongodb"
      type    = "A"
      ttl     = 1
      records = [
        module.mongodb.private_ip
      ]
    },
     {
      name    = "redis"
      type    = "A"
      ttl     = 1
      records = [
        module.redis.private_ip
      ]
    },
     {
      name    = "mysql"
      type    = "A"
      ttl     = 1
      records = [
        module.mysql.private_ip
      ]
    },
     {
      name    = "rabbitmq"
      type    = "A"
      ttl     = 1
      records = [
        module.rabbitmq.private_ip
      ]
    }
  ]
}