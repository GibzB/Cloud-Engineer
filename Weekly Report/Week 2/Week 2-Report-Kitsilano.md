# On-Prem to AWS S3 Data Synchronization Project 

## Overview

This project outlines the steps taken by our team during Week 2 to establish a data synchronization connection from an on-premises SMB share to an AWS S3 bucket using AWS DataSync. The goal was to create a cost-efficient and bandwidth-aware solution for data backup, with a disaster recovery plan in mind.

## Architecture

The basic architecture involves:

1. **On-Premises (Simulated):** A local laptop with Hyper-V enabled, hosting a virtual machine with an SMB share.
2. **AWS DataSync Agent:** Deployed within the virtualized on-premises environment.
3. **AWS DataSync Service:** Facilitating the data transfer.
4. **Amazon S3:** The destination bucket for the synchronized data.
5. **Disaster Recovery (Planned):** An EC2 instance capable of accessing the S3 files.

## Steps Performed

1. **On-Premises SMB Share Setup:**
   * Enabled Hyper-V on a local laptop.
   * Created a virtual machine within Hyper-V.
   * Configured an SMB share on the Windows file system within the VM.
2. **AWS S3 Bucket Creation:**
   * Created an S3 bucket in the desired AWS region to serve as the data destination.
   * Configured an S3 bucket policy to allow the DataSync agent to push files. (Note: Specific policy details would be included here in a full implementation).
3. **AWS DataSync Agent Deployment:**
   * Downloaded the AWS DataSync agent as a virtual appliance image.
   * Imported the agent image into Hyper-V.
   * Booted the VM and retrieved the agent's IP address from the console.
   * Accessed the DataSync agent management interface using the default credentials (`admin`/`password`).
4. **DataSync Location Creation:**
   * Created a source location in AWS DataSync, pointing to the on-premises SMB share using its IP address and share path.
   * Created a destination location in AWS DataSync, pointing to the created S3 bucket.
5. **DataSync Task Creation:**
   * Created a DataSync task, specifying the source and destination locations.
   * Configured task settings such as transfer options, scheduling (initially on-demand for testing), and logging.
   * Initiated the DataSync task to start the data transfer.
6. **Disaster Recovery Planning:**
   * Conceptualized the creation of an EC2 instance that can mount the S3 bucket (e.g., using S3FS or the AWS CLI) for data access in a disaster recovery scenario.

## Recommendations for Improvement

* **Security:**
  * **Implement a Site-to-Site VPN:** Establish a secure and private connection between the on-premises network and the AWS VPC using a Site-to-Site VPN. This will encrypt all traffic between the environments and enhance security.
  * **Secure Agent Management:** Change the default credentials for the DataSync agent immediately. Consider further securing access to the agent management interface.
  * **Principle of Least Privilege:** Ensure the IAM roles used by DataSync and the planned EC2 instance have only the necessary permissions.
* **Cost Efficiency & Bandwidth Utilization:**
  * **Data Compression:** Explore enabling data compression within the DataSync task settings to reduce the amount of data transferred over the internet.
  * **Scheduling:** Implement a schedule for the DataSync task that aligns with periods of lower network utilization.
  * **Filtering:** Utilize DataSync's filtering capabilities to only transfer necessary data, reducing transfer volume and costs.
  * **Lifecycle Policies:** Implement S3 lifecycle policies to manage storage costs by moving less frequently accessed data to lower-cost storage tiers (e.g., S3 Infrequent Access, S3 Glacier).
* **Resilience:**
  * **Multi-AZ Deployment (for EC2 DR):** If the disaster recovery plan involves a critical EC2 instance, consider deploying it across multiple Availability Zones for higher availability.

## Observability Implementation

To effectively monitor the data synchronization process and the overall system, consider implementing the following observability solutions:

### AWS CloudWatch

* **DataSync Metrics:** AWS DataSync automatically sends metrics to CloudWatch. You can monitor metrics such as:
  * `BytesCopied`: The total number of bytes copied.
  * `FilesCopied`: The total number of files copied.
  * `BytesTransferred`: The number of bytes transferred over the network.
  * `TaskStatus`: The current status of the DataSync task.
  * `TransferRate`: The rate at which data is being transferred.
* **CloudWatch Logs:** Configure DataSync to send logs to CloudWatch Logs for detailed information about the transfer process, including errors and warnings.
* **Alarms:** Set up CloudWatch alarms to notify you of specific events, such as task failures, high transfer rates, or errors.
* **EC2 Instance Monitoring (for DR):** Monitor the health and performance of the planned EC2 instance using standard CloudWatch metrics (CPU utilization, memory utilization, disk I/O, network traffic).

### Datadog

Datadog provides a more comprehensive observability platform that can integrate with AWS services.

* **AWS Integration:** Connect your AWS account to Datadog to automatically collect metrics and logs from DataSync, S3, and EC2.
* **DataSync Monitoring:** Datadog provides pre-built dashboards and monitors for AWS DataSync, allowing you to visualize key metrics and set up alerts.
* **S3 Monitoring:** Monitor S3 bucket metrics like storage usage, request latency, and error rates.
* **EC2 Monitoring:** Install the Datadog agent on the planned EC2 instance to collect detailed performance metrics, logs, and traces.
* **Custom Dashboards:** Create custom dashboards in Datadog to visualize the specific metrics that are most important to your team.
* **Alerting:** Configure advanced alerts in Datadog based on various metrics and conditions, with flexible notification options.
* **Log Management:** Centralize logs from DataSync, EC2, and other relevant services in Datadog for easier analysis and troubleshooting.

**Choosing Between CloudWatch and Datadog (or Both):**

* **CloudWatch:** A native AWS service that is tightly integrated and generally cost-effective for basic monitoring and alerting. It's a good starting point for essential observability.
* **Datadog:** A more feature-rich platform offering advanced visualization, alerting, log management, and integrations with a wider range of technologies. It's suitable for teams requiring more in-depth observability and centralized monitoring across diverse environments.

You can also use both tools in conjunction. For example, use CloudWatch for basic infrastructure monitoring and alerting, and Datadog for more detailed application-level insights and advanced analytics.

## Next Steps

* Implement the recommended security enhancements, particularly the Site-to-Site VPN.
* Integrate either CloudWatch or Datadog (or both) for comprehensive observability.
* Further optimize the DataSync task settings for cost and bandwidth efficiency.
* Fully implement the disaster recovery plan by setting up and testing the EC2 instance connection to S3.
