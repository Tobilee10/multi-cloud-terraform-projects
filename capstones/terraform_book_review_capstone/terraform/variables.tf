variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
  default     = "book-review"
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public (web tier) subnets, one per AZ"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "app_subnet_cidrs" {
  description = "CIDR blocks for private application tier subnets, one per AZ"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "db_subnet_cidrs" {
  description = "CIDR blocks for private database tier subnets, one per AZ"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "az_count" {
  description = "Number of availability zones to spread subnets across"
  type        = number
  default     = 2
}

variable "single_nat_gateway" {
  description = "If true, provision a single shared NAT Gateway for all AZs (lower cost, reduced HA). If false, provision one NAT Gateway per AZ (default, matches production HA requirement)."
  type        = bool
  default     = false
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
  description = "Additional common tags applied to all resources"
  type        = map(string)
  default     = {}
}

variable "db_instance_class" {
  description = "RDS instance class for both the primary MySQL instance and the read replica"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = <<-EOT
    Name of the initial database created on the primary RDS instance.
    Confirmed against the book-review-app backend (backend/src/config/db.js
    reads process.env.DB_NAME; docker-compose.yml sets DB_NAME=book_review_db).
  EOT
  type        = string
  default     = "book_review_db"
}

variable "db_master_username" {
  description = <<-EOT
    Master username for the RDS instance. Deliberately not "root" - AWS RDS
    for MySQL rejects "root" as a master username. Phase 6 (Application
    Deployment) must set the App tier's DB_USER env var to match this value.
  EOT
  type        = string
  default     = "admin"
}

variable "engine_version" {
  description = "MySQL engine version (major.minor prefix). AWS resolves to the latest matching patch version."
  type        = string
  default     = "8.0"
}

variable "allocated_storage" {
  description = "Allocated storage in GiB for the primary RDS instance"
  type        = number
  default     = 20
}

variable "backup_retention_period" {
  description = "Days to retain automated backups. Must be > 0 for the instance to be usable as a read replica source."
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = <<-EOT
    Whether the primary RDS instance has deletion protection enabled. Defaults
    to true (production-like safety). Must be explicitly overridden to false
    before terraform destroy can succeed on the primary instance.
  EOT
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Whether to skip taking a final snapshot when the primary RDS instance is deleted"
  type        = bool
  default     = false
}

variable "enable_cloudwatch_logs" {
  description = <<-EOT
    Whether to grant the App/Web tier instance roles CloudWatch Logs write
    permissions (logs:CreateLogGroup/CreateLogStream/PutLogEvents) and install
    the CloudWatch agent in user-data to ship PM2/application logs off-box.
    Defaults to false for capstone cost control - user-data/PM2 logs remain
    available on-instance (/var/log/user-data.log, `pm2 logs`) either way.
    Consumed by Phase 5 (Compute).
  EOT
  type        = bool
  default     = false
}

variable "jwt_secret_length" {
  description = <<-EOT
    Length (characters) of the random JWT signing secret generated for the
    backend (process.env.JWT_SECRET). Stored only in AWS Secrets Manager and
    fetched by the App tier at boot via its IAM instance role - never in
    Terraform outputs. Consumed by Phase 5 (Compute).
  EOT
  type        = number
  default     = 32
}

variable "enable_jwt_secret_rotation" {
  description = <<-EOT
    Whether to enable automatic rotation on the JWT signing secret in
    Secrets Manager. Defaults to false - rotating JWT_SECRET requires a
    coordinated app-side reload (existing signed tokens become invalid), so
    automatic rotation is deferred until a rotation Lambda / app support is
    designed. Consumed by Phase 5 (Compute).
  EOT
  type        = bool
  default     = false
}
