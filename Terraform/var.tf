#Varibles file for main.tf
variable "execution_role_arn" {
  description = "ARN of execution rule you are using for task definitions"
  type = string
}
variable "Mongodb_env" {
  description = "Mongodb environment variables"
  type = list(object({
    name  = string
    value = string
  }))
}
variable "subnet_ids" {
  description = "List of your subnetids you want to deploy"
  type = list(string)
}
variable "security_group" {
  description = "Securitygroup ids you want to attach for backend-goals service "
  type = list(string)
}
variable "security_group1" {
  description = "Securitygroup ids you want to attach for goals-react service"
  type = list(string)
}

variable "target_group_arn" {
  description = "ARN of target gorup"
  type = string
}