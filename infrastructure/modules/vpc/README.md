# VPC module

Creates an AWS VPC (DNS support and hostnames enabled) with any number of public and private subnets:

- Public subnets share a route table with a `0.0.0.0/0` route to an Internet Gateway.
- Private subnets share a route table with only the `local` route (no internet access).
- The VPC's default security group is managed with no rules.

NAT gateways and VPC endpoints are out of scope.

## Usage

```hcl
module "vpc" {
  source = "../../modules/vpc"

  name       = "demo"
  cidr_block = "10.0.0.0/16"

  public_subnets = {
    a = { cidr_block = "10.0.0.0/24", availability_zone = "eu-west-1a" }
    b = { cidr_block = "10.0.1.0/24", availability_zone = "eu-west-1b" }
  }

  private_subnets = {
    a = { cidr_block = "10.0.10.0/24", availability_zone = "eu-west-1a" }
    b = { cidr_block = "10.0.11.0/24", availability_zone = "eu-west-1b" }
  }

  tags = { Environment = "dev", Project = "continental-interview" }
}
```

See [`examples/basic`](../../examples/basic) for a runnable configuration. The module has no `provider` block; the caller sets the region.

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `name` | `string` | required | Name prefix used for the Name tag of every resource. |
| `cidr_block` | `string` | required | IPv4 CIDR block of the VPC, e.g. 10.0.0.0/16. |
| `tags` | `map(string)` | `{}` | Tags applied to every resource. The module-generated Name tag takes precedence. |
| `public_subnets` | `map(object({ cidr_block, availability_zone }))` | `{}` | Public subnets keyed by a stable name. Each gets a route to the Internet Gateway and auto-assigns public IPs. |
| `private_subnets` | `map(object({ cidr_block, availability_zone }))` | `{}` | Private subnets keyed by a stable name. They have no route to the internet. |

The VPC CIDR must be /16 to /28, and subnet CIDRs must be inside it (validated at plan time).

## Outputs

| Name | Description |
|---|---|
| `vpc_id` | VPC ID |
| `vpc_cidr_block` | VPC CIDR Block |
| `public_subnet_ids` | Map of public subnet key to subnet ID |
| `private_subnet_ids` | Map of private subnet key to subnet ID |
| `public_route_table_id` | Public Routing Table ID (`null` when there are no public subnets) |
| `private_route_table_id` | Private Routing Table ID |

## Design decisions

- **Subnets as maps with `for_each`**: any number of subnets in any AZs. Adding or removing one doesn't re-index the others, as `count` over a list would.
- **One route table per tier**: without NAT, all subnets of a tier need the same routes. Per-AZ tables only make sense with one NAT gateway per AZ.
- **Internet Gateway only when there are public subnets**: a private-only VPC gets no internet path at all.
- **Internet route as a separate `aws_route`**: callers can add their own routes (peering, NAT) to the exported route tables without the module removing them.
- **Default security group with no rules**: resources launched without an explicit security group are isolated (CIS benchmark).
- **Tags through a `tags` input**: merged with a `Name` tag (and `Tier` on subnets and route tables), so tagging works without provider `default_tags`.
- **Minimum version constraints only** (`>= 1.9`, `aws >= 6.0`): the caller pins exact versions. 1.9 is needed because the subnet validation references `var.cidr_block`.

Checkov findings that are intentional (public IPs on public subnets, no flow logs since the log destination belongs to the caller) are accepted in [`.checkov.baseline`](../../../.checkov.baseline).

## Testing

```bash
terraform init && terraform test   # mocked AWS provider, no credentials needed
```
