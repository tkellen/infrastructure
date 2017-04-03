# infrastructure
> my infrastructure, as code

## Setup
1. Install [AWSCLI], [Terraform] and [Make].
2. Ensure your local `~/.aws/credentials` has a profile entry matching the
   "state" you wish to manage (see providers in `terraform/states/*/config.tf`).

### What is this?
This repository contains the configuration for just about every web property
I maintain personally (there are about 10 left to add!). There is a separate "terraform" for each under `terraform/states/`.

### Commands Available
The most common lifecycle commands `init`, `plan`, and `apply` have been aliased
in the project's Makefile. If more complex management is needed, just `cd` into
the appropriate `terraform/state/` folder and run terraform directly.

#### make [state]/init
Prepare Terraform to manage the state you've specified. This must be run once
before the other commands are accessible.

#### make [state]/plan
Compare your local configuration to the actual deployed infrastructure and
prepare a plan to reconcile any differences.

#### make [state]/apply
After verifying plan, execute the changes.

#### make [state]/ssh-toggle
This toggles SSH access on and off for instances in the supplied state. This
is a cost saving measure. I am not currently running a load balancer in front of
my services, nor do I want to pay for a bastion host in each VPC, nor peer VPCs
to a single one. This may be obsoleted for some properties when this work is incorporated:
https://github.com/tkellen/microservices-architecture-boilerplate

#### make [state]/ssh-status
Displays if SSH is enabled or disabled for a given state.

#### make [init|plan|apply]
Executing make without a specified state (e.g. `make init`) will process *all*
states. **Be careful with this!**

[AWSCLI]: http://docs.aws.amazon.com/cli/latest/userguide/installing.html
[Terraform]: https://www.terraform.io/downloads.html
[Make]: https://www.gnu.org/software/software.html
