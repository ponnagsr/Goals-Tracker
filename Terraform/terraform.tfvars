#Sample variable values file
execution_role_arn="arn:aws:iam::**********:role/task-execution"
Mongodb_env = [
  { name = "MONGODB_USERNAME", value = "user" },
  { name = "MONGODB_PASSWORD", value = "password" },
  { name = "MONGODB_URL", value = "*****.mongodb.net" },
  { name = "MONGODB_NAME", value = "goals" }
]
subnet_ids=["subnet-01","subnet-02","subnet-3"]
security_group=["sg-0*********"]
security_group1 = [ "sg-0********" ]
target_group_arn = "arn:aws:elasticloadbalancing:*******:targetgroup/goals-tg/******"