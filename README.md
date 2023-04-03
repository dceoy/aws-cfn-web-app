aws-cfn-web-app
===============

AWS CloudFormation stacks of web applications

[![Lint](https://github.com/dceoy/aws-cfn-web-app/actions/workflows/lint.yml/badge.svg)](https://github.com/dceoy/aws-cfn-web-app/actions/workflows/lint.yml)

Installation
------------

1.  Check out the repository.

    ```sh
    $ git clone --recurse-submodules git@github.com:dceoy/aws-cfn-web-app.git
    $ cd aws-cfn-web-app
    ```

2.  Install [Rain](https://github.com/aws-cloudformation/rain) and set `~/.aws/config` and `~/.aws/credentials`.

3.  Push a container image to ECR.

4.  Deploy stacks for IAM roles.

    ```sh
    $ rain deploy \
        --params ProjectName=webapp-dev \
        iam-roles-for-apprunner.cfn.yml iam-roles-for-apprunner
    ```

5.  Deploy stacks for App Runner.

    - public web application

      ```sh
      $ rain deploy \
        --params ProjectName=webapp-dev,IamStackName=iam-roles-for-apprunner \
        apprunner-public.cfn.yml apprunner-public
      ```

    - private web application

      ```sh
      $ rain deploy \
          --params ProjectName=webapp-dev \
          aws-cfn-vpc-for-slc/vpc-private-subnets-with-endpoints.cfn.yml \
          webapp-dev-vpc-private
      $ rain deploy \
          --params ProjectName=webapp-dev,IamStackName=iam-roles-for-apprunner,VpcStackName=webapp-dev-vpc-private \
          apprunner-private.cfn.yml apprunner-private
      ```
