


# AWS EKS Cluster Authentication Configuration

This Terraform configuration manages the authentication for an AWS EKS cluster.



## AWS-AUTH Method

The aws-auth ConfigMap is used to create a static mapping between IAM principals, i.e. IAM Users and Roles, and Kubernetes RBAC groups. RBAC groups can be referenced in Kubernetes RoleBindings or ClusterRoleBindings.



## Prerequisites

- already up and ruuning EKS cluster see pervious Repo [EKS](https://github.com/xsalahdinX/terraform-eks-cluster)
- iam user and a role with permission trust that user [roles](https://github.com/xsalahdinX/terraform-eks-cluster/blob/main/user_roles/roles.tf)
- aws-auth helm chart  with role and rolebinding or cluster and clusterrolebinding
  

## Setup

1. Amazon EKS automatically creates the aws-auth ConfigMap in the kube-system namespace using either the API_AND_CONFIG_MAP or CONFIG_MAP options. This ConfigMap 
   manages access to the EKS cluster.
2. If you need to customize access to the EKS cluster with IAM roles, you'll have to deploy a new authentication setup.
3. To manage the deployment of the authentication ConfigMap more effectively, we use Helm.
4. However, deploying the authentication Helm chart may fail because the required Helm annotations and labels are missing from the original ConfigMap.
5. To resolve this, we add Kubernetes labels and annotations to the aws-auth ConfigMap. This allows Helm to replace the ConfigMap correctly during deployments.


Configuration

main.tf: Contains the Terraform configuration for retrieving the AWS account ID, setting up Kubernetes labels and annotations, and deploying Helm charts.
aws-auth/: Directory containing the AWS EKS authentication configuration.



Outputs

account_id: The AWS account ID retrieved from the AWS caller identity.
eks_cluster_name: The name of the EKS cluster.
eks_cluster_endpoint: The endpoint URL of the EKS cluster.
eks_cluster_certificate_authority_data: The Base64-encoded certificate authority data for the EKS cluster.



Feel free to adjust the content and structure of the README to better fit your project and its documentation needs. Let me know if you need further assistance!




```
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: gamil
  namespace: gamil
rules:
  - apiGroups: ["*"]
    resources: ["*"]
    verbs: ["*"]
```

```
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: gamil-binding
  namespace: gamil
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: gamil
subjects:
- kind: Group
  name: owners:gamil # This is the link between k8s and the IAM role I mapped in the mapRoles bit
```
