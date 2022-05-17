output "eks-endpoint" {
  value = aws_eks_cluster.reportportal.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.reportportal.certificate_authority[0].data
}

# Get outputs as variable
# Reference https://learn.hashicorp.com/tutorials/terraform/outputs
# K8S_ENDPOINT=$(terraform output -raw eks-endpoint)