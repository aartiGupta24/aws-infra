# Infrastructure as Code using Terraform

Aarti Gupta - 002193082

# Objective

We are going to start setting up our AWS infrastructure. This assignment will focus on setting up our networking resources such as Virtual Private Cloud (VPC), Internet Gateway, Route Table, and Routes. We will use Terraform for infrastructure setup and tear down.

# AWS Command Line Interface Setup

1. Setup your AWS account with an IAM user and access key pair for CLI access as suggested in previous assignments.
   
2. Run the following commands in your linux terminal - 
   ```
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   
   unzip awscliv2.zip
   
   sudo ./aws/install
   ```
3. Verify the installation with the following command - 
   ```
   aws --version
   ```

4. Configure your AWS CLI with two profiles - `dev` profile for AWS dev account and `demo` profile for AWS demo account.


# AWS Networking Setup using Terraform

## Install Terraform
1. Install Terraform on your linux environment using the following commands - 
   ```
   sudo apt update && sudo apt install terraform
   ```

2. Verify the installation with the following command - 
   ```
   terraform -help
   ```

## Build Infrastructure

1. Write your configuration to describe the following networking infrastructure - 
   1. Create Virtual Private Cloud (VPC).
   2. Create subnets in your VPC. You must create 3 public subnets and 3 private subnets, each in a different availability zone in the same region in the same VPC.
   3. Create an Internet Gateway. resource and attach the Internet Gateway to the VPC.
   4. Create a public route table. Attach all public subnets created to the route table.
   5. Create a private route table. Attach all private subnets created to the route table.
   6. Create a public route in the public route table created above with the destination CIDR block 0.0.0.0/0 and the internet gateway created above as the target.

2. EC2 Instance Configuration
   1. Create an EC2 security group for your EC2 instances that will host web applications.
   2. Add ingress rule to allow TCP traffic on ports `22`, `80`, `443`, and `port` on which your application runs from anywhere in the world.
   3.  This security group will be referred to as the `application` security group.
   4. Create an EC2 instance with the specifications mentioned in Assignment 04.
   
   <i><b>Note:</b>
      - Application security group should be attached to this EC2 instance.
      - Make sure the EBS volumes are terminated when EC2 instances are terminated.</i>

3. DB Security Group
   1. Create an EC2 security group for your RDS instances. 
   2. Add ingress rule to allow TCP traffic on the port `3306` for MySQL/MariaDB or `5432` for PostgreSQL.
   3. The Source of the traffic should be the `application` security group. 
         - Restrict access to the instance from the internet.
   4. This security group will be referred to as the `database` security group.

4. S3 Bucket
   1. Create a private S3 bucket with a randomly generated bucket name depending on the environment.
   2. Make sure Terraform can delete the bucket even if it is not empty.
         - To delete all objects from the bucket manually use the CLI before you delete the bucket you can use the following AWS CLI command that may work for removing all objects from the bucket. `aws s3 rm s3://bucket-name --recursive`. 
   3. Enable `default encryption for S3 Buckets`.
   4. Create a lifecycle policy for the bucket to transition objects from `STANDARD` storage class to `STANDARD_IA` storage class after 30 days.

5. RDS Instance and RDS Parameter Group
   - Create an RDS instance with the configuration mentioned in Assignment 05.

6. User Data
   1. EC2 instance should be launched with `user data`.
   2. Database username, password, hostname, and S3 bucket name should be passed to the web application using `user data`.
   3. The S3 bucket name must be passed to the application via EC2 user data.

7. IAM Policy
   1. `WebAppS3` the policy will allow EC2 instances to perform S3 buckets. This is required for applications on your EC2 instance to talk to the S3 bucket.
   2. Create the policy as mentioned in Assignment 05.

8. IAM Role
   - Create an IAM role `EC2-CSYE6225` for the EC2 service and attach the `WebAppS3` policy to it. You will attach this role to your EC2 instance.

## Run Infrastructure as Code

1. Initialize the directory using - `terraform init` command.

2. Create the infrastructure using - `terraform apply -var-file="<your_.tfvars_file_path>"` command.

<i>Note: The <b>Tfvars</b> files are used to manage variable assignments systematically for multiple environments, such test, dev, and prod. The <b>-var-file</b> flag is used to specify the tfvars file to load.</i>

3. Destroy all the resources using - `terraform destroy` command.




