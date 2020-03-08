# aws-lambda-website
Deploy a serverless website in AWS Lambda, without having to store assets in S3.

![Architecture](../assets/lambda-website.png)

This architecture does not require a public S3 bucket, allowing you to keep your website assets private.
## Structure
The Lambdas for both UI and API use deployment packages containing a python package and its dependencies.<br>
The Python packages can be found in the following locations: 
- <b>UI:</b>  src/ui <br>
- <b>API:</b> src/api <br>

The VueJS which renders the website is contained within the UI deployment package:
- src/ui/awswebsiteui

## Usage
- Make a new repo with this template
- Update the Python and VueJS with your changes
- Update the Terraform variables in deploy/variables.tf to your requirements. I recommend double checking the below variables:
    - region
    - availability_zones
    - (ui/api)_lambda_logs_retention
    - (ui/api)_lambda_memory_size
    - (ui/api)_lambda_timeout
- Update the region in deploy/provider.tf if required
- Add a Terraform backend if required
- Add the following variables to your GitHub secrets:
    - AWS_ACCESS_KEY_ID
    - AWS_SECRET_ACCESS_KEY
    - AWS_DEFAULT_REGION
- Every-time you push to master, the GitHub actions will deploy to your AWS environment

<b>IF USING IN PRODUCTION:</b><br>
Switch the self-signed certificate for the HTTPS listener for your own signed certificate.  
Make the change in: deploy/alb/main.tf

## Limitations
- As everything is stored in the Lambda, it must not exceed the Lambda storage/memory limits found here:
    https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html
- The Lambda target-group responses have a size limit, found here:
    https://docs.aws.amazon.com/elasticloadbalancing/latest/application/lambda-functions.html
    