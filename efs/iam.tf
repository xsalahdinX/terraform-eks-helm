data "aws_iam_openid_connect_provider" "eks-cluster-oidc" {
  url = local.issuer
}


resource "aws_iam_role" "efs-csi-role" {
  name = "efs-csi-role-role"
  
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Federated": "${data.aws_iam_openid_connect_provider.eks-cluster-oidc.arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${replace(data.aws_iam_openid_connect_provider.eks-cluster-oidc.arn.url, "https://", "")}:sub": "system:serviceaccount:kube-system:efs-csi-node-sa",
          "${replace(data.aws_iam_openid_connect_provider.eks-cluster-oidc.arn.url, "https://", "")}:sub": "system:serviceaccount:kube-system:efs-csi-controller-sa",
          "${replace(data.aws_iam_openid_connect_provider.eks-cluster-oidc.arn.url, "https://", "")}:aud": "sts.amazonaws.com"
        }
      }
    }
  ]
}
POLICY

  tags = {
    "ServiceAccountName"      = "efs-csi-iam-policy"
    "ServiceAccountNameSpace" = "kube-system"
  }
}


resource "aws_iam_role_policy_attachment" "efs-csi-iam-policy-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
  role       = aws_iam_role.efs-csi-role.name
  depends_on = [aws_iam_role.efs-csi-role]
}