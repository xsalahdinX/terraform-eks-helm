{
    "Version": "2008-10-17",
    "Statement": [
      {
        "Action": "s3:GetObject",
        "Effect": "Allow",
        "Resource": "arn:aws:s3:::${s3-bucket-name}/*",
        "Principal": "*"
      },
      {
        "Action": "s3:*",
        "Effect": "Deny",
        "Resource": "arn:aws:s3:::${s3-bucket-name}/*",
        "Principal": "*",
        "Condition": {
          "StringNotEquals": {
            "s3:action": "s3:GetObject"
          }
        }
      }
    ]
  }