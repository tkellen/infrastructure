# infrastructure
> my infrastructure, as code

## Setup
1. Install [AWSCLI], [Terraform] and Make.
2. Ensure your local `~/.aws/credentials` has a profile entry matching the
   "state" you wish to manage (see `terraform/states/*/providers.tf`).

### What is this?
This repository contains the configuration for just about every web property
I maintain personally. There is a separate "terraform" for each under `terraform/states/`.

### Commands Available
The most common lifecycle commands `init`, `plan`, and `apply` have been aliased
in the project's Makefile. If more complex management is needed, just `cd` into
the appropriate `terraform/state/` folder and run terraform directly.

#### make [state]-init
Prepare Terraform to manage the state you've specified. This must be run once
before the other commands are accessible.

#### make [state]-plan
Compare your local configuration to the actual deployed infrastructure and
prepare a plan to reconcile any differences.

#### make [state]-apply
After verifying plan, execute the changes.

#### make [init|plan|apply]
Executing make without a specified state (e.g. `make init`) will process *all*
states. **Be careful with this!**

[AWSCLI]: http://docs.aws.amazon.com/cli/latest/userguide/installing.html
[Terraform]: https://www.terraform.io/downloads.html
