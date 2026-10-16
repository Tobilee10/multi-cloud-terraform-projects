variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC these security groups belong to (from the network module)"
  type        = string
}

variable "ssh_ingress_cidr" {
  description = <<-EOT
    CIDR block permitted to SSH (port 22) into the web tier.

    WARNING: Defaults to 0.0.0.0/0 per explicit direction for a test-environment
    jump-host pattern (convenience tradeoff). This is a deliberate deviation from
    least-privilege network design and exposes every web-tier instance to
    internet-wide SSH scanning/brute-force attempts. Restrict this to a specific
    admin CIDR (e.g. an office/VPN egress IP) before any production use, or
    replace SSH entirely with AWS Systems Manager Session Manager, which requires
    no inbound port.
  EOT
  type        = string
  default     = "0.0.0.0/0"
}

variable "web_app_port" {
  description = <<-EOT
    Port the Web tier (Next.js) listens on. Placeholder default pending
    confirmation against the book-review-app repository before Phase 5/6
    (Compute / Application Deployment) - do not treat as final.
  EOT
  type        = number
  default     = 3000
}

variable "backend_port" {
  description = "Port the Application tier (Node/Express backend) listens on. Never exposed publicly."
  type        = number
  default     = 3001
}

variable "mysql_port" {
  description = "Port the managed MySQL database listens on. Only reachable from the App tier."
  type        = number
  default     = 3306
}

variable "tags" {
  description = "Common tags applied to all security group resources"
  type        = map(string)
  default     = {}
}
