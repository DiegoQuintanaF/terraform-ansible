# Terrafor and Ansible

This is a simple example of how to use Terraform and Ansible to create a simple infrastructure in AWS.
Configuration a simple php server with nginx and php-fpm.

## Requirements

- Terraform
  - [AWS provider]('https://registry.terraform.io/providers/hashicorp/aws/latest')
  - [Ansible provider]('https://registry.terraform.io/providers/ansible/ansible/latest')
- Ansible
  - Ansible plugin: [cloud.terraform]('https://github.com/ansible-collections/cloud.terraform')
- AWS account

## Usage

1. Clone this repository

   ```bash
   git clone
   ```

2. Initialize the Terraform configuration

   ```bash
   terraform init
   ```

3. Install de Ansible plugin: cloud.terraform

   ```bash
   ansible-galaxy collection install cloud.terraform
   ```

   This plugin is used to create the inventory file for Ansible.

4. Create the infrastructure with Terraform

   ```bash
   terraform apply -auto-approve
   ```

5. Wait for the infrastructure to be created and wait for the local-exec provisioner to run the Ansible playbook and write yes to the prompt.

6. Access the server using the public IP address + /test.php

7. Destroy the infrastructure

   ```bash
   terraform destroy -auto-approve
   ```
