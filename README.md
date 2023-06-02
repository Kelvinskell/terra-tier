# Terra-tier

Terra-tier is a python Flask application that is deployed on AWS using a three-tier architecture.
This project includes terraform scripts that automate the deployment of this application on AWS.

## How To Use
- Fork this repository.
- Clone your forked repository
- Navigate to the terraform directory
- Execute `terraform plan`
- If you are satisfied with the output of the plan, run `terraform apply`
- Navigate to the your AWS EC2 Console, go to the provisioned load balancer, copy your DNS name.
- The DNS name is also printed as output to your screen after you finish running `terraform apply`.
- Paste this DNS name into a web browser to access your appplication.

[Here](https://dev.to/kelvinskell/a-practical-guide-to-deploying-a-complex-production-level-three-tier-architecture-on-aws-2hf0) is also a guide for you if you wish to manually deploy this application.

### Happy Clouding!!!
