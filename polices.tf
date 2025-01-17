# {
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Principal": "*",
#             "Action": "*",
#             "Resource": "*"
#         }
#     ]
# }

# {
# 	"Version": "2012-10-17",
# 	"Statement": [
# 		{
# 			"Effect": "Allow",
# 			"Action": [
# 				"ssm:GetServiceSetting",
# 				"ssm:ResetServiceSetting",
# 				"ssm:UpdateServiceSetting"
# 			],
# 			"Resource": "arn:aws:ssm:region:account-id:servicesetting/ssm/managed-instance/default-ec2-instance-management-role"
# 		},
# 		{
# 			"Effect": "Allow",
# 			"Action": [
# 				"iam:PassRole"
# 			],
# 			"Resource": "arn:aws:iam::account-id:role/service-role/AWSSystemsManagerDefaultEC2InstanceManagementRole",
# 			"Condition": {
# 				"StringEquals": {
# 					"iam:PassedToService": [
# 						"ssm.amazonaws.com"
# 					]
# 				}
# 			}
# 		}
# 	]
# }