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

2. Initialize the directory using - `terraform init` command.

3. Create the infrastructure using - `terraform apply -var-file="<your_.tfvars_file_path>"` command.

<i>Note: The <b>Tfvars</b> files are used to manage variable assignments systematically for multiple environments, such test, dev, and prod. The <b>-var-file</b> flag is used to specify the tfvars file to load.</i>

4. Destroy all the resources using - `terraform destroy` command.




