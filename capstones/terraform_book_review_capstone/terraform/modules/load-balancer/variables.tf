variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC these load balancers and target groups belong to (from the network module)"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of the public (web tier) subnets the public ALB is placed in (from the network module)"
  type        = list(string)
}

variable "app_subnet_ids" {
  description = "IDs of the private application tier subnets the internal ALB is placed in (from the network module)"
  type        = list(string)
}

variable "public_alb_sg_id" {
  description = "ID of the public ALB security group (from the security module, Phase 2 - not modified here)"
  type        = string
}

variable "internal_alb_sg_id" {
  description = "ID of the internal ALB security group (from the security module, Phase 2 - not modified here)"
  type        = string
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

variable "certificate_arn" {
  description = <<-EOT
    ACM certificate ARN for the public ALB's HTTPS (443) listener. Optional -
    leave as the default empty string to defer HTTPS until a domain/certificate
    is provisioned. When set, an HTTPS listener forwarding to the web target
    group is created in addition to the HTTP (80) listener.
  EOT
  type        = string
  default     = ""
}

variable "web_health_check_path" {
  description = <<-EOT
    HTTP path the public ALB uses to health-check the Web tier target group.
    Placeholder assumption ("/") pending confirmation against the Next.js
    app's actual routes.
  EOT
  type        = string
  default     = "/"
}

variable "backend_health_check_path" {
  description = <<-EOT
    HTTP path the internal ALB uses to health-check the App tier target group.
    Confirmed against the book-review-app backend (backend/src/server.js) -
    the Express app only defines a root route (`app.get("/", ...)`) that
    returns a plain-text status string; there is no `/health` route. Set to
    "/" accordingly. If the backend later adds a dedicated health endpoint,
    update this default and the health_check.matcher on the backend target
    group together.
  EOT
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Common tags applied to all load balancer resources"
  type        = map(string)
  default     = {}
}
