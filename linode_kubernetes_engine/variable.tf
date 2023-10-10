variable "linode_token" {
  description = "Personal Access token to linode account"
  type        = string
  sensitive   = true
  
}

variable "source_path" {
  description = "The path of the source file or directory"
  default = "./config"
}

variable "destination_path" {
  description = "The path of the destination directory"
  default = "~/.kube/"
}