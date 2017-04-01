# infrastructure
> my infrastructure, as code

## What is this?
This repository contains the configuration for just about every website I've
made since the late 90s.

## Setup
1. Install [AWSCLI], [Terraform] and Make.
2. Ensure `~/.aws/credentials` has a profile with access keys that match
   any profiles listed in `terraform/states/*/profiles.tf`.

### Commands Available
There is a separate state file for each property under terraform/states. The
most common lifecycle commands `init`, `plan`, `apply` have been aliased in
the provided Makefile. If more complex management is needed, simply cd into
the appropriate state folder and run terraform directly.

### make [state]:init
Prepares Terraform to manage the state folder you've specified. This only needs
to be run once for each state.

### make [state]:plan
Compares your local configuration to the actual deployed infrastructure and
prepares a plan to reconcile any differences.

### make [state]:apply
After verifying your plan, running ` make apply` will execute the changes from
your last plan.


[AWSCLI]: http://docs.aws.amazon.com/cli/latest/userguide/installing.html
[Terraform]: https://www.terraform.io/downloads.html
