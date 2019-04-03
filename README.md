# Example of a Continuous Deliver pipeline with CodePipeline and CodeDeploy

Creating a simple Continuous Delivery pipeline allowing you to push changes from your GitHub repository to your EC2 Instances.

## Services

The following AWS services are used to create a Continuous Delivery pipeline.

* CodePipeline
* CodeDeploy
* CloudFormation
* EC2
* S3
* IAM

## Setup

Fork this repository.

Use the `./setup.sh` script to create a Continuous Delivery pipeline.

The script do the following:
1. Create S3 bucket
2. ZIP a lambda function
3. Upload the archive to S3 Bucket
4. Create a CloudFormation stack
5. Deploy function to Lambda service
6. Create a CodePipeline
7. Launch an EC2 instance into the default VPC of your default region. 
8. Run Lambda function to test static website on EC2 httpd service


The script will ask you for:
* S3 Bucket name for Lambda function artifact
* GitHub repository
* GitHub owner (username of individual or organisation)
* GitHub [OAuth Token with access to Repo](https://github.com/settings/tokens).

It might take a few minutes until the CodePipeline job has finished and the EC2 Instance is able to answer your HTTP request.
