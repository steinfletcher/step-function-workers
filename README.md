# Dynamic parallelism using AWS Step Functions

This repo contains an example of a simple fork join process using lambda and step functions.

![flow](stepfunctions_graph.png?raw=true "Step function workflow")

The controller will generate "work", where each "work" item is processed by a worker. The worker will output the processed result, then the collector will consume the result of each worker and produce a final aggregated result.

## Run the examples

This assumes you are using the default AWS profile.

### Terraform

Enter the tf directory and run terraform plan/apply, e.g.

```sh
cd tf
terraform init
terraform plan
terraform apply
```

### Deploy lambdas

Edit the `artifacts_s3_bucket_name` variable in the `scripts/deploy.sh` file to refer to a bucket you own.

```sh
make build && make deploy
```
