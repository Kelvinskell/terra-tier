# Terra-tier

Terra-tier is a Python Flask application that is deployed on AWS using a three-tier architecture.
This project includes terraform scripts that automate the deployment of this application on AWS.

## Running the App Locally with Docker Compose

In addition to deploying the terra-tier application on AWS using Terraform, you can run the application locally using Docker Compose. This approach is ideal for development, testing, or trying out the application without deploying it to the cloud.

### Prerequisites

Before you begin, ensure you have the following installed on your local machine or virtual instance:

- [Docker](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)

These tools are required to create containerized instances of the application and its required services (e.g., MySQL database).

### Steps to Run Locally

1. **Navigate to the Project Directory**: After cloning the repository, navigate to the root directory of the project where the `docker-compose.yml` file is located.

    ```bash
    cd path/to/terra-tier
    ```

2. **Environment Configuration**: The project includes a `.env` file located in the root directory, which contains the necessary environment variables required by the application and Docker Compose. Before running the application, you may want to modify the `.env` file with your preferred parameters.

    Default `.env` content:

    ```env
    SECRET_KEY=08dae760c2488d8a0dca1bfb
    API_KEY=f39307bb61fb31ea2c458479762b9acc
    MYSQL_DB=yourdbname
    MYSQL_USER=yourusername
    DATABASE_PASSWORD=Yourpassword@123
    MYSQL_HOST=db
    MYSQL_ROOT_PASSWORD=yourrootpassword
    ```

    You can replace these values in the `.env` file with your preferred values.

3. **Build and Start the Application**: Use a single Docker Compose command to build and start the application along with its dependencies (e.g., MySQL). This command also starts the services defined in the `docker-compose.yml` file.

    ```bash
    docker-compose up --build
    ```

    The `--build` flag ensures that Docker images are built using the latest version of the application. Omit this flag if you have not made any changes to the Dockerfile or application code and wish to start the containers faster.

4. **Accessing the Application**: Once the containers are up and running, the Flask application will be accessible via your web browser at `http://localhost:5000`. 

5. **Shutting Down**: To stop and remove the containers, networks, and volumes created by Docker Compose, run the following command in the same directory as your `docker-compose.yml` file:

    ```bash
    docker-compose down
    ```

### Additional Information

- **Database Initialization**: On the first run, the application will automatically create the necessary database tables.
- **Logs and Troubleshooting**: You can view logs for each service using `docker-compose logs [service_name]` to troubleshoot any issues that arise during startup or runtime.

## How To Use With Terraform
- Fork this repository.
- Clone your forked repository
- Navigate to the terraform directory
- Edit the `backend.tf` file. Add your own remote backend or use a local backend.
- Execute `terraform plan`
- If you are satisfied with the output of the plan, run `terraform apply`
- Navigate to the your AWS EC2 Console, go to the provisioned load balancer, copy your DNS name.
- The DNS name is also printed as output to your screen after you finish running `terraform apply`.
- Paste this DNS name into a web browser to access your appplication.

[Here](https://dev.to/kelvinskell/a-practical-guide-to-deploying-a-complex-production-level-three-tier-architecture-on-aws-2hf0) is a guide for you if you wish to manually deploy this application.

You can also choose to deploy this application using a CI/CD pipeline, specifically AWS CodePipeline.
[Here](https://dev.to/kelvinskell/devops-on-aws-codepipeline-in-action-60k) is an amazing resource I put up to guide on to deploy this application in a CI/CD pipeline using the blue/green deployment.

### Happy Clouding!!!
