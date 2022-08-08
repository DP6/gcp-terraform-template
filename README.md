
# What is Terraform and where do you use it

Terraform is infraestructure as code, deploying from this repository to the cloud with it's configurations on `.tf` files.

You can use this template for any Google Cloud Platform project, especially when talking about Cloud Functions. With git we keep track of changes made to the Cloud Functions codes and can even rollback if something went wrong.

## What you will need

- Basic git knowledge
- GCP project permissions
  - Cloud Functions
  - Cloud Storage
  - Source Repositories
  - Cloud Build 

You can host the repository on GitHub or GitLab then link with Source Repositories or create directly on your GCP project with Source Repositories.

# Setup

Change the variables on `environments/main/terraform.tfvars` and `environments/main/backend.tf` to match your project.

> To configure the backend, create a bucket with the same name as `artifact_bucket` on the Cloud Storage of your project.

## Setup the Cloud Build

After configuring the project on **Google Source Repositories**, create a trigger for every push on the repository.

The `cloudbuild.yaml` configuration file will handle the deploy. 

# Create a Cloud Function

1. Copy one folder from `templates/http` for http trigger functions or `templates/pubsub` for pubsub trigger functions into `src/functions`
2. Rename the folder you copied to the name of your function
3. Change the variables inside `local` on `yourFunction/_function.tf` file
4. Add the module of your function inside `src/functions/functions_modules.tf`:

```tf
module "yourFunction_function" {

  source = "./yourFunction"

  project         = var.project
  artifact_bucket = var.artifact_bucket
}
```

# Authenticating

To use or make any changes on GCP resources, you'll need to authenticate. Most apps will use the `GOOGLE_APPLICATION_CREDENTIALS` environment variable, that should have the path to your service account json file. More details on [Authenticating as a service account](https://cloud.google.com/docs/authentication/production).

```sh
$ export GOOGLE_APPLICATION_CREDENTIALS="path/to/serviceaccount.json"
```

Or you can use [`gcloud auth application-default`](https://cloud.google.com/sdk/gcloud/reference/auth/application-default) command to authenticate using your Google Account directly:
```sh
$ gcloud auth application-default login --project="<gcp-project-id>"
```

See https://cloud.google.com/sdk/docs/install for installing gcloud cli.


# Terraform

After doing any changes on the terraform files, go to your environment and make sure you run:

```sh
$ cd environments/main

$ terraform init
$ terraform plan
```

And see if there are any errors.

You can run `terraform apply` to deploy your code directly from your pc. **Altough, we recommend pushing your changes to the repository to run the CI on Cloud Build.**
