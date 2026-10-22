# DevOps Activity 2A — GCP Infrastructure and Application Deployment

## Project Overview

This project demonstrates infrastructure provisioning with Terraform, containerization with Docker, application deployment on Google Kubernetes Engine (GKE), and database integration with Cloud SQL for PostgreSQL.

The development application exposes REST API endpoints for health checks and user management. It retrieves database credentials from Google Cloud Secret Manager using Workload Identity.

## Architecture

```text
Developer / PowerShell
         |
         v
   Docker Image
         |
         v
   Artifact Registry
         |
         v
Google Kubernetes Engine (GKE)
         |
         +---- Flask REST API
         |          |
         |          +---- Workload Identity
         |          |          |
         |          |          v
         |          |    Secret Manager
         |          |          |
         |          |          v
         |          |    Database credentials
         |          |
         |          v
         +---- Cloud SQL PostgreSQL
                    |
                    v
              Users database

Terraform
   |
   +---- Development infrastructure
   |
   +---- Production infrastructure

Terraform state:
Google Cloud Storage with object versioning enabled
```

## Technology Stack

- Google Cloud Platform (GCP)
- Terraform
- Google Kubernetes Engine (GKE Autopilot)
- Docker and Docker Compose
- Artifact Registry
- Cloud SQL for PostgreSQL
- Google Cloud Secret Manager
- Workload Identity
- Python and Flask
- Kubernetes YAML manifests
- PowerShell

## Google Cloud Configuration

| Setting | Value |
|---|---|
| GCP project | `lunar-works-316500` |
| Region | `asia-south1` |
| Development GKE cluster | `activity-2a-dev-gke` |
| Production GKE cluster | `activity-2a-prod-gke` |
| Development Cloud SQL instance | `activity-2a-dev-postgres` |
| Production Cloud SQL instance | `activity-2a-prod-postgres` |
| Database name | `activity2a` |
| Artifact Registry repository | `devops-gcp-repo` |
| Terraform state bucket | `lunar-works-316500-tfstate` |

## Repository Structure

```text
devops-activity-2a/
├── app/
│   └── app.py
├── init-db/
│   └── init.sql
├── k8s/
│   └── dev-api.yaml
├── terraform/
│   └── environments/
│       ├── dev/
│       └── prod/
├── compose.yaml
├── Dockerfile
├── requirements.txt
└── README.md
```

## Prerequisites

Install and configure the following tools before running the project:

- Docker Desktop
- Google Cloud CLI (`gcloud`)
- Terraform
- `kubectl`
- An authenticated Google Cloud account with appropriate permissions

Authenticate and select the project:

```powershell
gcloud auth login
gcloud config set project lunar-works-316500
```

## Running Locally with Docker Compose

Start the local application and PostgreSQL services from the project root:

```powershell
docker compose up --build -d
```

Check the service status:

```powershell
docker compose ps
```

View application logs:

```powershell
docker compose logs app
```

Use the host port configured in `compose.yaml` to test the API. If the host port is 5000:

```powershell
Invoke-RestMethod http://127.0.0.1:5000/health
Invoke-RestMethod http://127.0.0.1:5000/users
```

Stop the local services when finished:

```powershell
docker compose down
```

The named PostgreSQL volume preserves database data across container recreation. Do not add `-v` to the shutdown command unless you intentionally want to remove the local database volume.

## Terraform Environments

Development and production use separate Terraform configurations and remote-state prefixes.

| Environment | Configuration directory | GCS state prefix |
|---|---|---|
| Development | `terraform/environments/dev` | `activity-2a/dev` |
| Production | `terraform/environments/prod` | `activity-2a/prod` |

The remote-state bucket is:

```text
gs://lunar-works-316500-tfstate
```

Object versioning is enabled on this bucket.

### Validate the development configuration

```powershell
terraform -chdir=terraform/environments/dev init
terraform -chdir=terraform/environments/dev validate
terraform -chdir=terraform/environments/dev plan
```

### Validate the production configuration

```powershell
terraform -chdir=terraform/environments/prod init
terraform -chdir=terraform/environments/prod validate
terraform -chdir=terraform/environments/prod plan
```

The development and production plans were previously checked and reported that no infrastructure changes were required.

Always inspect a plan before applying changes. Do not delete or manually edit Terraform state objects.

## Deploying the Development API to GKE

Refresh the development cluster credentials:

```powershell
gcloud container clusters get-credentials activity-2a-dev-gke --region asia-south1 --project lunar-works-316500
```

Check the Kubernetes context:

```powershell
kubectl config current-context
```

Apply the development API manifest:

```powershell
kubectl apply -f .\k8s\dev-api.yaml
```

Check deployment status:

```powershell
kubectl get deployment activity2a-api
kubectl get pods -l app=activity2a-api
kubectl get service activity2a-api
```

Wait for the application deployment:

```powershell
kubectl rollout status deployment/activity2a-api --timeout=180s
```

### Access the API using port forwarding

Start port forwarding:

```powershell
kubectl port-forward service/activity2a-api 8080:80
```

Keep that terminal open. In another PowerShell terminal, run:

```powershell
Invoke-RestMethod http://127.0.0.1:8080/health
Invoke-RestMethod http://127.0.0.1:8080/users
```

### API endpoints

| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/health` | Application health check |
| GET | `/users` | Retrieve user records |
| POST | `/users` | Create a user |

Example request to create a user:

```powershell
$body = @{
    name  = "Activity 2A Test"
    email = "activity2a-test@example.com"
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri http://127.0.0.1:8080/users `
    -Method Post `
    -ContentType "application/json" `
    -Body $body
```

Use a unique email address when repeating the request because the database enforces email uniqueness.

## Cloud SQL and Secret Manager

The development API connects to the development Cloud SQL PostgreSQL instance through its private IP address.

The application configuration uses these environment variables:

- `DB_HOST`
- `DB_PORT`
- `DB_NAME`
- `DB_USER`
- `GCP_PROJECT_ID`
- `DB_PASSWORD_SECRET`

The password is retrieved from Secret Manager rather than being embedded in the Kubernetes manifest.

The Kubernetes service account `activity2a-app` is associated with the Google Cloud service account:

```text
activity2a-dev-app@lunar-works-316500.iam.gserviceaccount.com
```

Workload Identity and the Secret Manager accessor permission were verified for the development application.

Never commit database passwords, API keys, service-account JSON keys, or other secret values to Git.

## Verification Results

The following development-environment checks were completed successfully:

- Flask API deployment on GKE.
- Kubernetes deployment with one available replica.
- Successful `/health` response.
- Successful retrieval of users using `GET /users`.
- Successful creation of a user using `POST /users`.
- Database records remained available after an application rollout.
- Cloud SQL connectivity.
- Workload Identity binding.
- Secret Manager accessor permission.
- Development Terraform plan reported no changes.
- Production Terraform plan reported no changes.
- Terraform state objects for development and production were present.
- GCS object versioning was enabled and verified.

The API deployment and endpoint tests documented here were performed against the development environment. The production infrastructure was Terraform plan-verified; this document does not claim that a production application deployment was tested.

## Troubleshooting

### Kubernetes API connection issues

Refresh credentials:

```powershell
gcloud container clusters get-credentials activity-2a-dev-gke --region asia-south1 --project lunar-works-316500
```

Check the context and pod status:

```powershell
kubectl config current-context
kubectl get pods -l app=activity2a-api
kubectl logs deployment/activity2a-api --tail=50
```

### API connection refused on localhost

Ensure the port-forward command is running in a separate terminal and has not exited:

```powershell
kubectl port-forward service/activity2a-api 8080:80
```

### Database errors

Check the application logs:

```powershell
kubectl logs deployment/activity2a-api --tail=100
```

Verify the database configuration and Secret Manager permissions without printing the password itself.

## Security and Cost Notes

- Keep database credentials in Secret Manager.
- Restrict IAM permissions to the identities that require them.
- Keep Terraform state files protected; they can contain sensitive information.
- Review Terraform plans before applying changes.
- Monitor GKE and Cloud SQL usage to manage Google Cloud charges.
- Do not delete infrastructure or Terraform state as a troubleshooting shortcut.

## Project Status

The local Docker Compose application and PostgreSQL database have been tested successfully. The API health check passed, and database records persisted after the containers were restarted.

Terraform formatting checks and validation passed for both development and production configurations. The development and production environments use separate Google Cloud Storage remote-state prefixes.

The development infrastructure teardown is currently incomplete. Google Cloud reports that a producer service is still using the development private Service Networking connection. The remaining development networking resources cannot yet be safely removed. Recreating the development infrastructure and performing final cloud verification are pending.

Production resources remain separate and must not be modified during development cleanup or recreation.

The project will be considered complete after the development environment can be cleanly destroyed and recreated, final validation evidence is collected, and all required submission files are reviewed.
## Development vs Production

Both environments use the same reusable Terraform modules and Google Cloud project and region. Their resource names and Cloud SQL sizing differ.

| Setting | Development | Production |
|---|---|---|
| VPC | `activity-2a-dev-vpc` | `activity-2a-prod-vpc` |
| Subnet | `activity-2a-dev-subnet` | `activity-2a-prod-subnet` |
| GKE cluster | `activity-2a-dev-gke` | `activity-2a-prod-gke` |
| Cloud SQL instance | `activity-2a-dev-postgres` | `activity-2a-prod-postgres` |
| Cloud SQL tier | `db-custom-1-3840` | `db-custom-2-7680` |
| Cloud SQL disk size | 10 GB | 20 GB |

Both environments use region `asia-south1` in project `lunar-works-316500`, while separate Terraform backend prefixes isolate their states.

The actual `terraform.tfvars` files are excluded from Git. The tracked `terraform.tfvars.example` files provide configuration examples. To use an environment, copy its example to `terraform.tfvars` and adjust its non-secret settings as necessary.

Database passwords must remain in Secret Manager and must not be added to these example files.
