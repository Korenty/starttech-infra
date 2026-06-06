# StartTech Infrastructure Management Platform (`starttech-infra`)

Welcome to the automated core infrastructure provisioning platform for StartTech. This repository contains the completely modularized Infrastructure as Code (IaC) architectures designed to spin up a high-availability, high-security three-tier environment on AWS using Terraform and automated GitHub Actions pipelines.

---

## 🏗️ System Architecture Overview

The infrastructure enforces strict isolation boundaries to protect core workloads:
* **Public Web Tier:** Houses the public-facing Application Load Balancer (ALB) across multiple Availability Zones to intercept ingress traffic.
* **Private Compute Tier:** Hosts the Golang API backend engine running inside an Auto Scaling Group (ASG), completely hidden from direct public internet exposure.
* **Isolated Data Tier:** Runs an Amazon ElastiCache Redis cluster across isolated database subnets, accessible strictly by the compute nodes.
* **Edge Routing & Storage Tier:** Hosts the frontend React static application bundle on Amazon S3, fronted globally by an Amazon CloudFront CDN using modern Origin Access Control (OAC).

---

## 📂 Repository Structure

```text
starttech-infra/
├── .github/
│   └── workflows/
│       └── infrastructure-deploy.yml   # Continuous Infrastructure Deployment Pipeline
├── terraform/
│   ├── main.tf                         # Root orchestration control plane
│   ├── variables.tf                    # Global input parameter declarations
│   ├── outputs.tf                      # Computed runtime outputs interface
│   ├── terraform.tfvars.example        # Reference parameters template
│   └── modules/
│       ├── networking/                 # VPC, Subnets, Gateways, Security Groups
│       ├── compute/                    # ALB, Launch Templates, Auto Scaling Groups
│       ├── storage/                    # Secure S3 Bucket, CloudFront CDN with OAC
│       └── monitoring/                 # ElastiCache Redis, CloudWatch Log Groups
├── scripts/
│   └── deploy-infrastructure.sh        # Local automation shell runner
└── monitoring/
    ├── cloudwatch-dashboard.json       # Visual Operations Console configuration
    ├── alarm-definitions.json          # Metric threshold triggering rules
    └── log-insights-queries.txt        # Diagnostic analysis query suite


🚀 Deployment Workflows
1. Automated CI/CD (GitHub Actions)
Any commit or merged Pull Request pushing into the main branch automatically triggers the Infrastructure Deployment workflow.

Code Verification: Automatically executes structural code styling formatting (terraform fmt) and compilation compliance reviews (terraform validate).

Dry-Run Blueprinting: Generates a complete architecture modification log (terraform plan).

Active Provisioning: Automatically applies resource graph updates safely directly to active cloud assets (terraform apply).


2. Manual Local Deployment Script
If manual verification or disaster recovery setups are needed, use the custom interactive automation shell script:

chmod +x scripts/deploy-infrastructure.sh
./scripts/deploy-infrastructure.sh

🔒 Security Hardening Standards
Least-Privilege Network Access: Security Groups block all default ingress vectors. The compute instances accept traffic exclusively from the ALB proxy boundary on port 8080.

Zero Public S3 Leakage: The React frontend S3 bucket uses explicit aws_s3_bucket_public_access_block rules. Upstream data fetching is restricted exclusively to the global CloudFront service principal using signature-v4 signed headers via Origin Access Control (OAC).

Cryptographic Secrets Isolation: Zero access keys, tokens, or environment vars are hardcoded inside configuration templates. Production authentication values are bound dynamically at runtime via encrypted GitHub Repository Secrets.

📊 Monitoring & Log AnalyticsCentralized Logging: System outputs and engine loops are shipped directly into the centralized CloudWatch Log Group /starttech/production/backend-application.Operational Metrics Dashboard: The dashboard maps real-time tracking for compute fleet node counts, average cluster CPU stress velocities, edge transaction processing, and session cache hits.Automated Alarms: Monitors system thresholds and instantly triggers notifications if cluster CPU usage breaks $\ge 80\%$ or if target nodes fail runtime health probes.




