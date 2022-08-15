
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

> Obs.: Apply the same variables on `environments/pre_main/terraform.tfvars`

## Setup the Cloud Build

After configuring the project on **Google Source Repositories**, create a trigger for every push on the repository.

The `cloudbuild.yaml` configuration file will handle the build and deploy. 

# Create a Cloud Function

1. Copy one folder from `templates/functions/http` for http trigger functions or `templates/functions/pubsub` for pubsub trigger functions into `src/functions`
2. Rename the folder you copied to the name of your function
3. Edit `{http|pubsub}_config.json` to fit your Cloud Function

As the only required field is `topic_name` for PubSub Functions, if you have an empty json it'll be applied the default values:

```jsonc
{
  "topic_name": "daily_at_5",     /* Required for PubSub Functions, not necessary for http functions */
  // "is_typescript": false,      /* Optional */
  // "description": "",           /* Optional */
  // "entry_point": "main",       /* Optional */
  // "runtime": "nodejs16",       /* Optional */
  // "timeout": 540,              /* Optional */
  // "available_memory_mb": 128,  /* Optional */
  // "environment_variables": {}  /* Optional */
}
```

> Warning: the JSON file can't have comments, so remove them before pushing to the repository

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

To apply the changes locally:

```sh
# The deploy of pre_main is only necessary on the first time
$ cd environments/pre_main
$ terraform init
$ terraform apply -auto-approve

$ cd ../main
$ terraform init
$ terraform apply -auto-approve
```

> **Altough, we recommend pushing your changes to the repository to run the CI on Cloud Build.**
