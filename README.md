# terraform-eks-helm
# AWS EKS Cluster Authentication Configuration

This Terraform configuration manages the authentication for an AWS EKS cluster, including retrieving the AWS account ID, setting up Kubernetes labels and annotations, and deploying Helm charts.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- AWS CLI configured with necessary permissions.
- Helm installed on your local machine.

## Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/xsalahdinX/terraform-eks-helm.git
   cd terraform-eks-helm/aws-auth
2.Initialize the Terraform configuration:
3.Review the configuration in main.tf to ensure it matches your requirements.
4.Apply the Terraform configuration:


Configuration

main.tf: Contains the Terraform configuration for retrieving the AWS account ID, setting up Kubernetes labels and annotations, and deploying Helm charts.
aws-auth/: Directory containing the AWS EKS authentication configuration.



Outputs

account_id: The AWS account ID retrieved from the AWS caller identity.
eks_cluster_name: The name of the EKS cluster.
eks_cluster_endpoint: The endpoint URL of the EKS cluster.
eks_cluster_certificate_authority_data: The Base64-encoded certificate authority data for the EKS cluster.



Feel free to adjust the content and structure of the README to better fit your project and its documentation needs. Let me know if you need further assistance!
