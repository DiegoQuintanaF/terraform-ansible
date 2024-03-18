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

1. Initialize the Terraform configuration

   ```bash
   terraform init
   ```

2. Install de Ansible plugin: cloud.terraform

   ```bash
   ansible-galaxy collection install cloud.terraform
   ```

   This plugin is used to create the inventory file for Ansible.

3. Create the infrastructure with Terraform

   ```bash
   terraform apply -auto-approve
   ```

4. Wait for the infrastructure to be created and wait for the local-exec provisioner to run the Ansible playbook and write yes to the prompt.

5. Access the server using the public IP address + /test.php

6. Destroy the infrastructure

   ```bash
   terraform destroy -auto-approve
   ```

## Evidence

### [Terraform apply 1]('https://res.cloudinary.com/drvoywub5/image/upload/v1710752404/image_uploader/strpld5ydq0y8vtrx0f3.png')

<img src="https://res.cloudinary.com/drvoywub5/image/upload/v1710752404/image_uploader/strpld5ydq0y8vtrx0f3.png">

### [Terraform apply 2]('https://res.cloudinary.com/drvoywub5/image/upload/v1710752580/image_uploader/akfmsv1ycfz8wn9sxdos.png')

<img src="https://res.cloudinary.com/drvoywub5/image/upload/v1710752580/image_uploader/akfmsv1ycfz8wn9sxdos.png">

### [Terraform apply 3 (ansible)]('https://res.cloudinary.com/drvoywub5/image/upload/v1710752679/image_uploader/xcx7ep6fwsmpf9kdq64s.png')

<img src="https://res.cloudinary.com/drvoywub5/image/upload/v1710752679/image_uploader/xcx7ep6fwsmpf9kdq64s.png">
