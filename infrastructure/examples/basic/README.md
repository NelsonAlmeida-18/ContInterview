# Example: basic

Calls [`modules/vpc`](../../modules/vpc) with the assignment's reference input:

- VPC `10.0.0.0/16`.
- 2 public subnets (`10.0.0.0/24`, `10.0.1.0/24`) and 2 private subnets (`10.0.10.0/24`, `10.0.11.0/24`), spread over `eu-west-1a` and `eu-west-1b`.
- `Environment` and `Project` tags.

## Why a separate example root

**Module vs. root.** The module is a *library*: no provider, no backend, minimum version constraints only. This directory is a *root configuration*, i.e. what a real consumer writes. It owns:
- the `provider "aws"` block (region),
- exact version pins (`~> 1.16.0`, `~> 6.0`),
- the committed `.terraform.lock.hcl` (aws 6.68.0, hashes for linux/darwin amd64 and arm64, plus windows amd64).

**Tags.** `Environment` and `Project` are passed through the module's `tags` input rather than provider `default_tags`. That exercises the module's tagging interface, which the assignment asks for.

## Run

```bash
cd infrastructure/examples/basic
terraform init
terraform fmt -check
terraform validate
terraform plan      # needs AWS credentials; state is local (no backend block)
```

## Lock file

**Updating the provider.** Run `terraform init -upgrade`, then refresh the hashes for every platform:

```bash
terraform providers lock -platform=linux_amd64 -platform=linux_arm64 \
  -platform=darwin_amd64 -platform=darwin_arm64 -platform=windows_amd64
```
