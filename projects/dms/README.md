# Sleekcode Data Management System
> Making business data driven since 2007.

## System Requirements
1. Install VirtualBox (https://www.virtualbox.org/)
2. Install Vagrant (http://www.vagrantup.com/)
4. Install vagrant-hostsupdater (run `vagrant plugin install vagrant-hostsupdater`)
5. Install Ansible
   - `pip install ansible` via [pip](http://pip.readthedocs.org/en/latest/installing.html) (All Platforms)
   - `brew install ansible` via [homebrew](http://brew.sh/) (OSX)
   - `apt-get/yum install ansible` (Linux)

## Setup
1. Run `vagrant up`
2. Place database dump in `src/[dist].sql`
3. Run `make [dist]/init`
