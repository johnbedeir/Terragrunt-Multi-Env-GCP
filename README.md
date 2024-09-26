# Terragrunt Multi-Env Infrastructure on GCP

<img src=imgs/cover.png>

This project establishes a comprehensive infrastructure using Terragrunt to manage reusable Terraform modules across two environments: **dev** and **prod**. The setup includes deploying critical **Google Cloud** resources and services to ensure high availability, scalability, and monitoring.

### Key Resources:

- **GKE Clusters**: Kubernetes clusters for container orchestration and management.
- **Cloud SQL Instances**: Managed relational databases tailored for each environment.
- **VPCs & Subnets**: Custom Virtual Private Clouds with public and private subnets for network isolation.
- **Firewall Rules**: Network security configurations for controlling traffic.
- **Monitoring Stack**: Integration of **Prometheus**, **Alert Manager**, and **Grafana** for observability, alerting, and monitoring.
- **ArgoCD**: Continuous Delivery solution for automated Kubernetes deployments in both environments.

## Project Structure

- `environments/`: Contains the environment-specific Terragrunt configurations for **dev** and **prod** environments.
  - `dev/`: Contains the `terragrunt.hcl` file for the dev environment.
  - `prod/`: Contains the `terragrunt.hcl` file for the prod environment.
- `modules/`: Contains the reusable Terraform modules for resources such as GKE clusters, VPCs, and Cloud SQL.
  - `gke.tf`: GKE cluster configuration.
  - `vpc.tf`: VPC configuration.
  - `nat.tf`: Network configuration.
  - `cloud_secret_manager.tf`: Generating Database Passwords.
  - `cloud_sql.tf`: Cloud SQL configuration.
  - `provider.tf`: GCP provider configuration.
  - `variables.tf`: Input variables used across modules.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed.
- [Terragrunt](https://terragrunt.gruntwork.io/) installed.
- GCP SDK (gcloud) configured with proper access to the required GCP project and region.

## Commands

To deploy the infrastructure for both **dev** and **prod** environments, navigate to the `environments` directory and run the following commands:

Before building the infrastructure you will need to create a `service account` with `key` and download the `JSON` credentials file to be able to connect to your `GCP account`, so run the following script first:

```
./run-me-first.sh
```

This will remove any previously created `service account` and create a new one then download the `JSON` credentials file into modules directory

`NOTE: We remove previous service accounts and keys because you are limited to 10 just in case you build the project several times`

### 1. Initialize the Terraform backend

```bash
terragrunt run-all init
```

### 2. Plan the infrastructure changes

Run the following command to review the planned changes for **dev** and **prod**:

```bash
terragrunt run-all plan
```

<img src=imgs/dev.png>

<img src=imgs/prod.png>

### 3. Apply the infrastructure changes

After reviewing the plan, you can apply the changes for both environments using:

```bash
terragrunt run-all apply
```

<img src=imgs/output.png>

This will deploy the resources to both the **dev** and **prod** environments.

### Accessing GKE Clusters

To switch between the **dev** and **prod** GKE clusters, use the following commands:

- For **dev**:

  ```bash
  gcloud container clusters get-credentials dev-cluster --zone europe-west1-d --project dev-project-id
  ```

  <img src=imgs/dev-cluster.png>

- For **prod**:

  ```bash
  gcloud container clusters get-credentials prod-cluster --zone europe-west1-b --project prod-project-id
  ```

  <img src=imgs/prod-cluster.png>

  These commands update your kubeconfig file, allowing you to interact with the desired Kubernetes cluster.

### Connecting to Cloud SQL Databases

To connect to your **dev** or **prod** Cloud SQL instances, follow these steps:

1. **Find the Cloud SQL Endpoint**:

   - You can find the Cloud SQL instance's IP address in the **GCP Console** under **Cloud SQL > Instances**.
   - Alternatively, retrieve it via the Terraform outputs.

2. **Retrieve Cloud SQL Username and Password** from **Secret Manager**:

   - The Cloud SQL credentials (username and password) are stored in **Secret Manager**.
   - Go to **GCP Secret Manager** and look for secrets like `dev-cluster-1-cloudsql-secrets` or `prod-cluster-1-cloudsql-secrets`.

3. **Connect using MySQL**:

   - For **dev** environment:

     ```bash
     mysql -h dev-sql-instance-ip -u <username-from-secret-manager> -P 3306 -p
     ```

   - For **prod** environment:

     ```bash
     mysql -h prod-sql-instance-ip -u <username-from-secret-manager> -P 3306 -p
     ```

### Teardown All Environments

To destroy the infrastructure for both dev and prod environments, you can use the following commands.

```bash
terragrunt run-all destroy
```

## Notes

- Each environment (dev/prod) has its own `terragrunt.hcl` file, which points to the shared Terraform modules located in the `modules/` directory.
- Changes applied will be specific to the environment (either dev or prod), but running `terragrunt run-all` ensures that both environments are handled simultaneously.
