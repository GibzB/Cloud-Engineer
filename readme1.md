# Website Architecture - Test and Prod Environments (AWS)

This document provides a visual breakdown of the website architecture, including both Production (live) and Staging (testing) environments, hosted on AWS.

## High-Level Overview

The architecture is designed for high availability, scalability, and separation of the live website from the testing environment. Users access the website through AWS Route 53, which directs traffic to either the Production or Staging Application Load Balancer (ALB). The ALBs distribute traffic across EC2 instances running the website application. Data is stored in separate RDS MySQL databases and cached using separate ElastiCache Redis clusters for each environment. Files are stored in Amazon S3.

## User Access Flow

1. **User Request:** A user types the website address (e.g., `www.yourdomain.com` or `staging.yourdomain.com`) into their browser.
2. **DNS Resolution (Route 53):** AWS Route 53 translates the website name into the IP address of the appropriate Application Load Balancer (Production or Staging).
3. **Load Balancing (ALB):** The Application Load Balancer receives the request and distributes it to one of the healthy EC2 instances within its respective Auto Scaling Group.
4. **Application Processing (EC2 Instances):**
   * The EC2 instance runs the website application (Laravel with PHP-FPM).
   * The application processes the request, potentially interacting with the database (RDS), cache (ElastiCache), and storage (S3).
5. **Response to User:** The application sends the generated web page back through the ALB and to the user's browser.

## Production Environment Breakdown

+-------------------------+     +-------------------------+     +-------------------------+
|        Route 53         | --> |     ALB (Production)    | --> |    ASG (Production)    |
+-------------------------+     +-------------------------+     +-------------------------+
|                             |
v                             v
+-------------------------+     +-------------------------+
|   EC2 Instances (Prod)  | --> |   RDS MySQL (Prod)    |
| (PHP-FPM, Laravel App)  |     +-------------------------+
+-------------------------+          ^
|                             |
v                             v
+-------------------------+     +-------------------------+
|  ElastiCache Redis (Prod)|     |     S3 Bucket (Prod)    |
+-------------------------+     +-------------------------+
|
v
+-------------------------+
|   CloudWatch Logs (Prod)|
+-------------------------+
