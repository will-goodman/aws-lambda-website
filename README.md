# aws-lambda-website
Deploy a serverless website in AWS Lambda, without having to store assets in S3.

![Architecture](../assets/lambda-website.png)

## Usage
- Use this template to make a new repository
- Update src/ui/awswebsiteui/aws-lambda-website/src/App.vue with your VueJS
- Store any assets you want to use on your website in src/ui/awswebsiteui/aws-lambda-website/src/assets
- Store your AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and AWS_DEFAULT_REGION in your repo's GitHub Secrets
- When you push your changes, the action in .github/workflows/Deploy.yml will automatically deploy to your AWS environment

