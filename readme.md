# Directus DevOps Deployment using Terraform and GitLab CI/CD

## Project Description

This project demonstrates a fully automated DevOps pipeline that provisions AWS infrastructure using Terraform and deploys Directus (Headless CMS) using Docker via GitLab CI/CD.

The entire workflow is automated, including:

- Infrastructure provisioning
- Application deployment
- Health validation
- Infrastructure cleanup

No manual SSH access is required. Everything is executed through GitLab CI/CD pipeline stages.

---

## Live Application

Directus is accessible at:

http://ip-adress:8055

Admin Credentials:

Email: admin@example.com  
Password: Admin@123

---

## Architecture Overview

Components used:

- AWS EC2 (Ubuntu 22.04 LTS)
- Terraform (Infrastructure as Code)
- GitLab CI/CD (Automation Pipeline)
- Docker & Docker Compose (Container Deployment)
- Directus Headless CMS
- SSH Key Authentication (Generated using Terraform)
---

## 📁 Repository Structure

```bash
directus-devops-assessment/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── versions.tf
├── docker-compose.yml
├── .gitlab-ci.yml
├── .gitignore
└── README.md
```

 <img width="1919" height="883" alt="Screenshot 2026-02-23 075322" src="https://github.com/user-attachments/assets/ccb0e68e-c8d2-40f5-8317-5b317cafb90c" />
---

## Infrastructure Provisioning using Terraform

<img width="1914" height="759" alt="Screenshot 2026-02-23 081343" src="https://github.com/user-attachments/assets/11265bba-8c69-46f7-aff6-6256965e0edb" />


Terraform provisions the following AWS resources:

- TLS Private Key (RSA 4096-bit)
- AWS Key Pair
- Security Group with inbound rules:
  - Port 22 (SSH)
  - Port 80 (HTTP)
  - Port 8055 (Directus)
- EC2 Instance (t3.micro, Ubuntu 22.04)
- Docker and Docker Compose installation using user_data

Terraform Outputs:

- EC2 Public IP
- SSH Private Key
- Directus URL

---

## GitLab CI/CD Pipeline

The pipeline consists of the following stages:

<img width="1919" height="875" alt="Screenshot 2026-02-23 075237" src="https://github.com/user-attachments/assets/56620517-a019-48b1-beb7-30143c5f3443" />



### Stage 1: Validate

Validates Terraform configuration

Commands used:

terraform init  
terraform validate  

---

### Stage 2: Plan

Creates Terraform execution plan

terraform plan  

---

### Stage 3: Provision

Creates AWS infrastructure

<img width="1919" height="861" alt="Screenshot 2026-02-23 075933" src="https://github.com/user-attachments/assets/9cc20fd2-6433-4864-93cd-c8cab622994e" />


terraform apply  

Extracts:

- server_ip.txt
- ssh_key.pem

These files are passed to next stages as artifacts.

---

### Stage 4: Deploy

Pipeline performs the following actions:

<img width="1919" height="989" alt="Screenshot 2026-02-23 081316" src="https://github.com/user-attachments/assets/20f7a1fe-3165-4ae7-ad30-461f3075b175" />


- Connects to EC2 using SSH
- Copies docker-compose.yml
- Creates .env file dynamically using CI/CD variables
- Starts Directus container

docker-compose up -d

---

### Stage 5: Test

Verifies application health

curl http://SERVER_IP:8055/server/health

Confirms Directus is running successfully.

---

### Stage 6: Cleanup (Manual)

Destroys infrastructure

terraform destroy

This stage is manually triggered when cleanup is required.

---

## Environment Variables

Configured in GitLab CI/CD Variables:

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_DEFAULT_REGION
- ADMIN_EMAIL
- ADMIN_PASSWORD
- DB_PASSWORD
- DIRECTUS_SECRET

Sensitive data is never stored in the repository.

---

## Security Best Practices

The following files are excluded using .gitignore:

- terraform.tfstate
- .env
- ssh_key.pem
- server_ip.txt
- Terraform plan files

Secrets are stored securely in GitLab CI/CD variables.

---

## Deployment Workflow

Step 1: Push code to GitLab repository

Step 2: Pipeline runs automatically:

- Validate
- Plan

Step 3: Manually trigger:

- Provision stage

Step 4: Pipeline continues automatically:

- Deploy
- Test

Step 5: Access Directus via browser

---

## DevOps Concepts Demonstrated

- Infrastructure as Code (Terraform)
- CI/CD Pipeline Automation
- Cloud Infrastructure Provisioning (AWS)
- Containerized Application Deployment
- Secure Secret Management
- Automated Deployment Workflow
- SSH Key Authentication
- GitLab CI/CD Pipeline Design

---

## Challenges and Solutions

Challenge: Docker not available immediately after instance creation  
Solution: Added wait logic in deploy stage

Challenge: Infrastructure recreated on every pipeline run  
Solution: Configured Terraform remote state using AWS S3 backend

Challenge: Secure SSH access  
Solution: Generated SSH key dynamically using Terraform

---

## Author

Name: Mukhtar Buddabai Gari  
Role: DevOps Engineer  

GitHub: https://github.com/sheikh-mukhtar  
LinkedIn: https://linkedin.com/in/mukhtarsheikh  

---

## Conclusion

This project successfully demonstrates a complete DevOps pipeline that automates infrastructure provisioning, application deployment, and validation using Terraform and GitLab CI/CD.

<img width="1919" height="947" alt="Screenshot 2026-02-23 081031" src="https://github.com/user-attachments/assets/b2f23c91-e576-4b5e-98f4-cd9a39e5ae9f" />


The deployment is fully automated, secure, and follows DevOps best practices.

