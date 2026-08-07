aws_region   = "ap-south-1"
project_name = "multi-cloud-devops-platform"
environment  = "prod"

vpc_cidr = "10.0.0.0/16"

availability_zones = [
  "ap-south-1a",
  "ap-south-1b"
]

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

instance_type = "t3.micro"

key_name = "your-key-pair-name"

ami_id = ""

eks_cluster_version = "1.33"

eks_node_instance_types = [
  "t3.medium"
]

eks_desired_nodes = 2
eks_min_nodes     = 1
eks_max_nodes     = 3

db_name     = "appdb"
db_username = "admin"

db_password = "ChangeThisStrongPassword123!"

db_instance_class = "db.t3.micro"
db_engine_version = "16"

ecr_repositories = [
  "frontend",
  "backend",
  "api"
]