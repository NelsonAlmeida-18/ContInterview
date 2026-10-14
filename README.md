# ContInterview

## Objective
Create a reusable Terraform module that provisions a basic AWS networking environment
consisting of a VPC, public subnets, and private subnets.
The goal of this assignment is to demonstrate your ability to write clean, maintainable, and
reusable Terraform code while applying fundamental AWS networking concepts.

## Repository layout

```
.
├── .github/workflows/pr_workflow.yml  # pre-commit + terraform test, no AWS credentials
├── .pre-commit-config.yaml
├── .terraform-version
└── infrastructure/
    ├── modules/vpc/               # the module
    └── examples/basic/            # example consumer (assignment reference input)
```

| Path | What it is | Why it exists |
|---|---|---|
| [`infrastructure/modules/vpc`](infrastructure/modules/vpc) | Reusable VPC module: VPC, IGW, public/private subnets, route tables | The deliverable. No provider or backend, so it works in any account/region |
| [`infrastructure/examples/basic`](infrastructure/examples/basic) | Root configuration calling the module with the assignment's example input | Shows how the module is consumed |

## Quick start

```bash
cd infrastructure/examples/basic
terraform init && terraform validate
terraform plan                 # needs AWS credentials (not required by the assignment)
```

Tests and checks need no AWS credentials:

```bash
(cd infrastructure/modules/vpc && terraform init -backend=false && terraform test)
pre-commit install && pre-commit run --all-files
```
