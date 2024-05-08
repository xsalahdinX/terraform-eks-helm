# AWS EKS Cluster Authentication Configuration

This Terraform configuration manages the authentication for an AWS EKS cluster.



## AWS-AUTH Method

The aws-auth ConfigMap is used to create a static mapping between IAM principals, i.e. IAM Users and Roles, and Kubernetes RBAC groups. RBAC groups can be referenced in Kubernetes RoleBindings or ClusterRoleBindings.



## Prerequisites

- already up and ruuning EKS cluster see pervious Repo [EKS](https://github.com/xsalahdinX/terraform-eks-cluster)
- iam user and a role with permission trust that user  
- aws-auth helm chart  with role and rolebinding or cluster and clusterrolebinding
  

## Setup

1. Amazon EKS automatically creates the aws-auth ConfigMap in the kube-system namespace using either the API_AND_CONFIG_MAP or CONFIG_MAP options. This ConfigMap manages access to the EKS cluster.
2. if we want to customize the access to eks cluster with our iam roles we have to deploy a new auth
3. we use helm solution to control the deployment of auth configmap
4. when trying to deploy the auth helm chart it will error as the helm annotations and labels does not exit in the orginal configmap
5. so kubernets label and annotations blocks has been created to add the helm labels to the aws-auth to allow helm to replace it when deployments   


Configuration

main.tf: Contains the Terraform configuration for retrieving the AWS account ID, setting up Kubernetes labels and annotations, and deploying Helm charts.
aws-auth/: Directory containing the AWS EKS authentication configuration.



Outputs

account_id: The AWS account ID retrieved from the AWS caller identity.
eks_cluster_name: The name of the EKS cluster.
eks_cluster_endpoint: The endpoint URL of the EKS cluster.
eks_cluster_certificate_authority_data: The Base64-encoded certificate authority data for the EKS cluster.



Feel free to adjust the content and structure of the README to better fit your project and its documentation needs. Let me know if you need further assistance!
