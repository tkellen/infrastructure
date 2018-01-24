# infrastructure
> infrastructure configuration and legacy source code

## Setup
1. Install [AWSCLI], [Terraform] & [Make].
2. Ensure `~/.aws/credentials` has an entry with administrative access keys
   matching the `profile` for the project. The profile name can be found in
   `terraform/{project}/variables.tf` under the `provider "aws" {}` block.

### Commands Available
The most common lifecycle commands `init`, `plan`, and `apply` have been aliased
in the project's Makefile. If more complex management is needed, just `cd` into
the appropriate `terraform/project/` folder and run terraform directly.

#### make {project}/init
Prepare Terraform to manage the project you've specified. This must be run once
before the other commands are accessible.

#### make {project}/plan
Compare your local configuration to the actual deployed infrastructure and
prepare a plan to reconcile any differences.

#### make {project}/apply
After verifying plan, execute the changes.

#### make {project}/ssh-toggle
This toggles SSH access on and off for instances in the supplied project. This
is a cost saving measure. I am not currently running a load balancer in front of
my services, nor do I want to pay for a bastion host in each VPC, nor peer VPCs
to a single one. This may be obsoleted for some properties when this work is incorporated:
https://github.com/tkellen/microservices-architecture-boilerplate

#### make {project}/ssh-status
Displays if SSH is enabled or disabled for a given project.

#### make [init|plan|apply]
Executing make without a specified project (e.g. `make init`) will process *all*
projects. **Be careful with this!**

[AWSCLI]: http://docs.aws.amazon.com/cli/latest/userguide/installing.html
[Terraform]: https://www.terraform.io/downloads.html
[Make]: https://www.gnu.org/software/software.html
