#!/bin/bash -e

DEFAULT_VPC=$(aws ec2 describe-vpcs --filter Name=isDefault,Values=true --query Vpcs[0].VpcId --output text)
SUBNET=$(aws ec2 describe-subnets --filter Name=vpc-id,Values=$DEFAULT_VPC --query Subnets[0].SubnetId --output text)

echo "Enter the S3 bucket name:"
read BUCKET_NAME

echo "Enter the Stack name:"
read STACK_NAME

echo "Enter the GitHub repository:"
read GITHUB_REPO

echo "Enter the GitHub owner:"
read GITHUB_OWNER

echo "Enter the GitHub OAuth Token:"
read GITHUB_OAUTH_TOKEN


aws s3 mb s3://$BUCKET_NAME

cd lambda && zip -r lambda.zip * 

aws s3 cp lambda.zip s3://$BUCKET_NAME

cd ..

aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://deploy/stack.yml --parameters ParameterKey=BucketName,ParameterValue=$BUCKET_NAME ParameterKey=GitHubOwner,ParameterValue=$GITHUB_OWNER ParameterKey=GitHubOAuthToken,ParameterValue=$GITHUB_OAUTH_TOKEN ParameterKey=GitHubRepo,ParameterValue=$GITHUB_REPO ParameterKey=VPC,ParameterValue=$DEFAULT_VPC ParameterKey=Subnet,ParameterValue=$SUBNET --capabilities CAPABILITY_IAM

echo "Creating the CloudFormation stack, this will take a few minutes ..."

aws cloudformation wait stack-create-complete --stack-name $STACK_NAME

echo "Done! Send an HTTP request to the following URL, please."
aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].Outputs[?OutputKey==`URL`].OutputValue' --output text