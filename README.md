# Terraform Configuration for AWS EC2 Web Server with Ansible Provisioning

This Terraform configuration deploys a secure web server on AWS using an EC2 instance. It sets up an RSA key pair, provisions the instance with required software, and configures security group rules for SSH, HTTP, and HTTPS access. Additionally, it automates further setup using Ansible.

## Resources Created

1. **TLS Private Key**
   - Generates an RSA private key (4096 bits) for SSH access.

2. **AWS Key Pair**
   - Creates an AWS key pair using the generated public key.

3. **AWS Security Group**
   - Allows inbound traffic for:
     - SSH (Port 22)
     - HTTP (Port 80)
     - HTTPS (Port 443)
   - Permits all outbound traffic.

4. **AWS EC2 Instance**
   - Launches an EC2 instance with the following:
     - User data script to install Python 3.
     - Security group for access control.
     - The generated SSH key for secure access.
     - Custom tags (e.g., `Name: WebServer1`).

5. **Null Resource**
   - Runs an Ansible playbook (`setup_vm.yml`) to configure the instance further:
     - Saves the private key to `/tmp/private.pem`.
     - Adds the EC2 instance's public IP to an inventory file.
     - Executes the playbook using the private key.

## Prerequisites

- **Terraform**: Installed and configured.
- **AWS CLI**: Installed and authenticated with proper permissions.
- **Ansible**: Installed on your local machine.
- A valid AMI ID for your AWS region to replace `ami-0040d891e3c1949fc`.
- Update the `instance_type` variable in your Terraform configuration.

## Usage

1. **Clone the Repository**  
   Clone this repository to your local machine.

2. **Initialize Terraform**  
   Run `terraform init` to initialize the Terraform working directory.

3. **Plan the Deployment**  
   Execute `terraform plan` to review the resources that will be created.

4. **Apply the Configuration**  
   Deploy the resources with `terraform apply`. Confirm the action when prompted.

5. **Verify Ansible Setup**  
   - Ensure the `setup_vm.yml` playbook is in the same directory.
   - The playbook will automatically configure the server.

6. **Access the Server**  
   - Use the generated private key (`/tmp/private.pem`) to SSH into the server:
     ```bash
     ssh -i /tmp/private.pem ubuntu@<public_ip>
     ```

## Security Notes

- Ensure the private key is handled securely and removed when no longer needed.
- Restrict access to the security group rules (e.g., limit SSH access to your IP).

## Customization

- Update the `ami` ID in the EC2 resource to match your region.
- Modify the `setup_vm.yml` Ansible playbook for additional server configurations.

## Clean-Up

To remove all resources created by this configuration, run:
```bash
terraform destroy