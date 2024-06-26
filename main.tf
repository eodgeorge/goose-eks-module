module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "vpc"

  azs             = data.aws_availability_zones.azs.names
  cidr            = var.cidr
  private_subnets = var.private_subnets_cidr_blocks
  public_subnets  = var.public_subnets_cidr_blocks

  create_database_nat_gateway_route = true
  enable_nat_gateway                = true
  single_nat_gateway                = true
  enable_dns_hostnames              = true
  enable_vpn_gateway                = true


  tags = {
    "k8s-cluster" = "vpc"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.13.0"

  cluster_name                             = "eks-cluster"
  cluster_version                          = "1.29"
  cluster_endpoint_public_access           = true
  cluster_endpoint_private_access          = true
  enable_cluster_creator_admin_permissions = true #*********
  enable_irsa                              = true


  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_security_group_additional_rules = {
    "bastion_rule" = {
      description              = "Access EKS from Bastion host."
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      type                     = "ingress"
      source_security_group_id = module.sg.Bastion_SG-id
    }
    "jenkins_rule" = {
      description              = "Access EKS from Jenkins controller."
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      type                     = "ingress"
      source_security_group_id = module.sg.jenkins-sg-id
    }
  }

  eks_managed_node_groups = {
    worker-node = {
      min_size     = 1
      max_size     = 5
      desired_size = 2

      instance_types = ["t2.medium"]
    }
  }
}


# data "aws_eks_cluster" "cluster" {
#   name = module.eks.cluster_name
# }

# data "aws_eks_cluster_auth" "cluster" {
#   name = module.eks.cluster_name
# }

data "template_file" "kubeconfig" {
  template = <<-EOF
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: "${module.eks.cluster_certificate_authority_data}"
    server: "${module.eks.cluster_endpoint}"
  name: "${module.eks.cluster_name}"
contexts:
- context:
    cluster: "${module.eks.cluster_name}"
    user: "${module.eks.cluster_name}-user"
  name: "${module.eks.cluster_name}"
current-context: "${module.eks.cluster_name}"
kind: Config
preferences: {}
users:
- name: "${module.eks.cluster_name}-user"
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws
      args:
      - eks
      - get-token
      - --cluster-name
      - "${module.eks.cluster_name}"
EOF
}

resource "local_file" "kubeconfig" {
  content  = data.template_file.kubeconfig.rendered
  filename = "${path.module}/kubeconfig.yaml"
}


data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.39.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}


module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  eks_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
      most_recent              = true
    }
    coredns = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
  }

  # enable_aws_load_balancer_controller          = true
  enable_cluster_autoscaler                    = true
  enable_argocd                                = true
  enable_metrics_server                        = true
  enable_external_dns                          = true
  enable_cert_manager                          = true
  enable_kube_prometheus_stack                 = true
  enable_secrets_store_csi_driver_provider_aws = true
  enable_secrets_store_csi_driver              = true
  secrets_store_csi_driver = {
    name       = "secrets-store-csi-driver"
    version    = "1.4.3"
    repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
    chart      = "secrets-store-csi-driver"
    set = [{
      name  = "syncSecret.enabled"
      value = "true"
      },
      {
        name  = "enableSecretRotation"
        value = "true"
      },
      {
        name  = "rotation.enabled"
        value = "true"
      }
  ] }
  enable_ingress_nginx = true
  ingress_nginx = {
    name          = "ingress-nginx"
    chart_version = var.chart_version
    namespace     = var.namespace
    repository    = var.repo
    values        = [templatefile("${path.module}/route53-ssl/ingress-values.yaml", {})]
  }
  tags = {
    "k8s-cluster" = "add-ons"
  }
}

data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }

  depends_on = [module.eks_blueprints_addons]
}

module "bastion" {
  source        = "./bastion"
  ami           = module.keypair.eks-ami-id
  bastion-SG    = module.sg.Bastion_SG-id
  key_name      = module.keypair.public-key
  public-subnet = module.vpc.public_subnets[0]
  prv-key       = module.keypair.private-key
  kubeconfig    = local_file.kubeconfig.content
  access-key    = var.access-key
  secret-key    = var.secret-key
  regions       = var.region
  cluster_name  = module.eks.cluster_name
}

module "jenkins" {
  source         = "./jenkins"
  ami            = module.keypair.eks-ami-id
  jenkins-SG     = module.sg.jenkins-sg-id
  key_name       = module.keypair.public-key
  private-subnet = module.vpc.private_subnets[0]
  agent_ip       = module.jenkins.jenkins-agtcnt-ip
  kubeconfig     = local_file.kubeconfig.content
  access-key     = module.iam.access-key
  secret-key     = module.iam.secret-key
  regions        = var.region
  cluster_name   = module.eks.cluster_name

}

module "rds" {
  source         = "./rds"
  password       = jsondecode(module.secretmanager.rds_secret_string)["password"]
  username       = jsondecode(module.secretmanager.rds_secret_string)["username"]
  rds-SG         = module.sg.rds_SG-id
  private-subnet = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
}

module "secretmanager" {
  source = "./secretmanager"
}

module "sg" {
  source = "./sg"
  vpc    = module.vpc.vpc_id
}

module "keypair" {
  source = "./keypair"
}

module "iam" {
  source = "./iam"
}

module "sonarqube" {
  source        = "./sonarqube"
  ami           = module.keypair.eks-ami-id
  sonarqube-SG  = module.sg.Sonarqube_SG-id
  key_name      = module.keypair.public-key
  public-subnet = module.vpc.public_subnets[0]
}

module "route53-ssl" {
  source               = "./route53-ssl"
  domain_name          = "thinkeod.com"
  a_domain_name        = "*.thinkeod.com"
  nginx_ingress_lb_dns = try(data.kubernetes_service.nginx_ingress.status.0.load_balancer.0.ingress.0.hostname, null)
  subdomains = ["ingress-nginx", "argocd", "prometheus"]
}

# value = data.kubernetes_service.nginx_ingress.status.0.load_balancer.0.ingress.0.hostname


#  nginx_ingress_lb_dns = [data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname]
# resource "aws_iam_role" "eks_irsa_role" {
#   name = "eks-irsa-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           Federated = module.eks.oidc_provider_arn
#         },
#         Action = "sts:AssumeRoleWithWebIdentity",
#         Condition = {
#           StringEquals = {
#             "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:my-serviceaccount"
#           }
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_policy" "eks_irsa_policy" {
#   name        = "eks-irsa-policy"
#   description = "Policy for EKS IRSA"
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "eks:DescribeCluster",
#           "eks:ListClusters",
#           "eks:ListUpdates",
#           "eks:ListFargateProfiles"
#         ],
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "eks_irsa_policy_attachment" {
#   role       = aws_iam_role.eks_irsa_role.name
#   policy_arn = aws_iam_policy.eks_irsa_policy.arn
# }   

# resource "helm_release" "cert_manager" {
#   ...
#   depends_on = [module.aws_load_balancer_controller]
# }

# resource "helm_release" "ingress_nginx" {
#   ...
#   depends_on = [module.aws_load_balancer_controller]
# }