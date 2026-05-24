# Serverless TODO Application on AWS

## Overview

This project is a fully serverless TODO application built on AWS using Terraform for Infrastructure as Code (IaC).

The application demonstrates a production-style cloud-native architecture using:

* AWS Lambda microservices
* Amazon API Gateway REST APIs
* Amazon DynamoDB
* Amazon S3
* Amazon CloudFront
* Amazon Route53
* AWS Certificate Manager (ACM)
* Terraform

The frontend is a React Single Page Application (SPA) served globally through CloudFront, while the backend consists of multiple Lambda-based microservices exposed through API Gateway.

---

# Architecture

```text
Users
   ↓
CloudFront CDN
   ↓
S3 Bucket (React SPA)
   ↓
Browser Frontend
   ↓
API Gateway REST API
   ↓
Lambda Microservices
   ↓
DynamoDB
```

---

# AWS Services Used

| Service            | Purpose                    |
| ------------------ | -------------------------- |
| Amazon S3          | Hosts React frontend build |
| Amazon CloudFront  | CDN for frontend delivery  |
| Amazon API Gateway | REST API management        |
| AWS Lambda         | Backend microservices      |
| Amazon DynamoDB    | NoSQL database             |
| Amazon Route53     | DNS management             |
| AWS ACM            | SSL/TLS certificates       |
| CloudWatch Logs    | Lambda and API logs        |
| IAM                | Access control             |

---

# Key Features

## Frontend

* React SPA
* Hosted on private S3 bucket
* Served through CloudFront CDN
* HTTPS enabled using ACM
* Custom Route53 domain

## Backend

* Serverless microservices architecture
* REST APIs using API Gateway
* Separate Lambda functions for:

  * Create TODO
  * Get all TODOs
  * Get TODO by ID
  * Delete TODO
* DynamoDB single-table design
* CORS enabled

## Infrastructure

* Fully managed using Terraform
* Reproducible deployments
* Infrastructure as Code
* Modular AWS resources

---

# Project Structure

```text
.
├── frontend/
│   ├── src/
│   ├── public/
│   └── dist/
│
├── terraform/
│   ├── api_gw.tf
│   ├── cloudfront.tf
│   ├── dynamodb.tf
│   ├── lambda.tf
│   ├── iam.tf
│   ├── route53.tf
│   ├── s3.tf
│   └── outputs.tf
│
├── lambdas/
│   ├── create_todo/
│   ├── get_todos/
│   ├── get_todo_by_id/
│   └── delete_todo/
│
└── README.md
```

---

# DynamoDB Design

The application uses a single-table DynamoDB design.

## Table Schema

| Attribute | Type               | Description     |
| --------- | ------------------ | --------------- |
| user_id   | Partition Key (PK) | User identifier |
| todo_id   | Sort Key (SK)      | TODO identifier |

## Example Item

```json
{
  "user_id": "USER#demo-user",
  "todo_id": "TODO#1234",
  "title": "Learn Terraform",
  "description": "Build serverless apps on AWS",
  "completed": false,
  "created_at": "2026-05-24T10:00:00Z"
}
```

---

# API Endpoints

| Method | Endpoint         | Description      |
| ------ | ---------------- | ---------------- |
| POST   | /todos           | Create TODO      |
| GET    | /todos           | Fetch all TODOs  |
| GET    | /todos/{todo_id} | Fetch TODO by ID |
| DELETE | /todos/{todo_id} | Delete TODO      |

---

# Terraform Deployment

## Initialize Terraform

```bash
terraform init
```

## Preview Changes

```bash
terraform plan
```

## Deploy Infrastructure

```bash
terraform apply
```

---

# Lambda Packaging

Example packaging command:

```bash
zip create_todo.zip app.py
```

Terraform automatically uploads Lambda ZIP packages during deployment.

---

# Frontend Deployment

## Build React Application

```bash
npm run build
```

## Upload to S3

```bash
aws s3 sync dist/ s3://YOUR_BUCKET_NAME
```

## Invalidate CloudFront Cache

```bash
aws cloudfront create-invalidation \
  --distribution-id YOUR_DISTRIBUTION_ID \
  --paths "/*"
```

---

# Security Features

* HTTPS using ACM certificates
* CloudFront Origin Access Control (OAC)
* Private S3 bucket
* IAM least privilege access
* Lambda execution roles
* Route53 custom domains
* CORS configuration for APIs

---

# API Gateway Configuration

The backend uses:

* API Gateway REST API
* Lambda proxy integrations
* Regional API endpoint
* Custom domain mapping
* Route53 alias records

---

# CloudFront Configuration

CloudFront is configured with:

* HTTPS redirection
* SPA routing support
* Custom error responses
* Compression enabled
* S3 private origin
* TLS 1.2 minimum

---

# Learning Outcomes

This project demonstrates:

* Serverless architecture patterns
* Infrastructure as Code using Terraform
* AWS networking and DNS
* API Gateway integrations
* Lambda microservices
* DynamoDB single-table design
* CloudFront CDN configuration
* Secure frontend hosting
* Custom domain management

---

# Cost Optimization

The architecture is designed to stay within low-cost AWS usage:

* Lambda pay-per-use model
* DynamoDB on-demand billing
* CloudFront PriceClass_100
* S3 static hosting
* No NAT Gateway usage

---

# Example Production Flow

```text
User Request
    ↓
CloudFront CDN
    ↓
React SPA
    ↓
API Gateway
    ↓
Lambda Function
    ↓
DynamoDB
    ↓
JSON Response
```

---

# Technologies Used

* Terraform
* React
* Python
* AWS Lambda
* API Gateway
* DynamoDB
* CloudFront
* Route53
* ACM
* S3
* Github Workflows
---