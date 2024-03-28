# Apigee X Lambda JavaScript Sample
This sample lets you create an API that can create a signed request (AWS4-HMAC-SHA256) to securely access an AWS Lambda function.

It uses a 
- KVM to store the AWS Lambda function key and secret, and other configuration information (e.g. region, host)
- an Assign Message policy to prepare the request
- a JavaScript policy to create the canonical values for the signature
- an Assign Message policy to create the HMAC keys and signature

## Disclaimer

This example is not an official Google product, nor is it part of an official Google product.

## License

This material is copyright 2019, Google LLC. and is licensed under the Apache 2.0 license.
See the [LICENSE](LICENSE) file included.

This code is open source.

## Prerequisites
1 Existing AWS Lambda function
2 Apigee X
3 Apigeecli

## Setup Instructions
1. Clone the respository
    ```
    git clone https://github.com/kurtkanaskie/apigeex-lambda-javascript.git
    ```
2. Install apigeecli 
    ```
    curl -L https://raw.githubusercontent.com/apigee/apigeecli/main/downloadLatest.sh | sh -
    ```
3. Get the details from you Lambda function (keys, function URL and region
4. Edit the `env.sh` and configure the ENV vars and source `env.sh`
    ```
    source env.sh
    ```

## Deploy Apigee components
Next, let's deploy our lambda-javascript-v1 proxy. 
```
deploy-lambda-javascript-v1.sh
```
Test the proxy
```
curl -s https://$APIGEE_HOST/lambda-javascript | jq
{
  "message": "Hello Kurt from Lambda hello-app",
  "eventPath": "/",
  "eventQueryString": ""
}

curl -s https://$APIGEE_HOST/lambda-javascript/ | jq
{
  "message": "Hello Kurt from Lambda hello-app",
  "eventPath": "/",
  "eventQueryString": ""
}

curl -s https://$APIGEE_HOST/lambda-javascript/somepathsuffix | jq
{
  "message": "Hello Kurt from Lambda hello-app",
  "eventPath": "/somepathsuffix",
  "eventQueryString": ""
}

curl -s https://$APIGEE_HOST/'lambda-javascript/somepathsuffix?hello=sunshine&goodbye=rain' | jq
{
  "message": "Hello Kurt from Lambda hello-app",
  "eventPath": "/somepathsuffix",
  "eventQueryString": "hello=sunshine&goodbye=rain"
}

curl -s https://$APIGEE_HOST/'lambda-javascript/prompt?question=What%20is%20the%20meaning%20of%20life%3F' | jq
{
  "message": "Hello Kurt from Lambda hello-app",
  "eventPath": "/prompt",
  "eventQueryString": "question=What%20is%20the%20meaning%20of%20life%3F"
}

curl --location --request POST https://$APIGEE_HOST/'lambda-javascript/prompts?prompt=What%20is%20the%20meaning%20of%20life' \
--header 'Content-Type: application/json' \
--data-raw '{
    "prompt":"What is the meaning of life?",
    "options": {
        "detailLevel":"HIGH",
        "errorTolerance":"LOW",
        "mode":"SYNCHRONOUS"
    }
}'
{
  "message": "Hello Kurt from Lambda hello-app",
  "eventPath": "/prompts",
  "eventQueryStringDecoded": "prompt=What is the meaning of life",
  "eventBody": {
    "prompt": "What is the meaning of life?",
    "options": {
      "detailLevel": "HIGH",
      "errorTolerance": "LOW",
      "mode": "SYNCHRONOUS"
    }
  }
}
```
## Conclusion & Cleanup

Congratulations! You've successfully created Apigee API to securely access ans AWS Lambda function.

To clean up the artifacts created source your `env.sh` script and run the following to delete your sample CORS proxy:

```bash
./clean-lambda-javascript-v1.sh
```
# References
## AWS Lambda
- [Getting Started with Lambda](https://docs.aws.amazon.com/lambda/latest/dg/getting-started.html)
- [Creating Signed Request](https://docs.aws.amazon.com/IAM/latest/UserGuide/create-signed-request.html)
- [AWS SDK JS v4.js](https://github.com/aws/aws-sdk-js/blob/master/lib/signers/v4.js)

## Apigee X
- [Apigee HMAC Calculation Functions with AWS example](https://cloud.google.com/apigee/docs/api-platform/reference/message-template-intro#hmac-functions)
- [Apigee Javascript Crypto Object - SHA-256](https://cloud.google.com/apigee/docs/api-platform/reference/javascript-object-model#cryptoobjectreference-workingwithsha256objects)
- [apigeecli](https://github.com/apigee/apigeecli)

## TODO
- Include body in canonical string