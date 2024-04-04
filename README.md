# IaC MBA Activity

<h1 align="center">
  <img alt="Jurfest Apps Logo" src="./assets/logo.png" width="250px"/>
    <br>
</h1>

<h4 align="center">
  Infraestructure as Code MBA Activity
</h4>

<p align="center">
<img alt="Last commit on GitHub" src="https://img.shields.io/github/last-commit/Jurfest/iac-mba-activity">
<img alt="Made by Jurfest" src="https://img.shields.io/badge/made%20by-Jurfest-%20">
<img alt="Project top programing language" src="https://img.shields.io/github/languages/top/Jurfest/iac-mba-activity">
<img alt="GitHub license" src="https://img.shields.io/github/license/Jurfest/iac-mba-activity">
</p>

<p align="center">
  <a href="#computer-technologies">Technologies</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#automated-setup">Automated setup</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#how-to-run-terraform-and-ansible">How to run Terraform and Ansible</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#page_facing_up-license">License</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#mailbox_with_mail-get-in-touch">Get in touch</a>
</p>
<br><br>

### :computer: Technologies

This project was developed with the following technologies:

- [Terraform](https://www.terraform.io)
- [Ansible](https://www.ansible.com)
- [Docker](https://www.docker.com)
- [Azure](https://azure.microsoft.com/en-us/free)
- [Redis](https://redis.io)

### Setup

Clone repository

```bash
# Clone the repository
$ git clone https://github.com/jurfest/iac-mba-activity.git

# Go to project's folder
$ cd https://github.com/Jurfest/iac-mba-activity

# Open vscode - if wanted - or continue in the terminal or open another IDE
$ code .

```

Connect to your Azure account

```bash
# Opens a new window to connect to the Azure cloud provider
$ az login

```

Generate ssh-keys folder

```bash
# Create ssh-keygen folder
$ mkdir ssh-keygen

$ cd ssh-keygen

# Generate public and private key files by responding to prompt questions
$ ssh-keygen

$ cd ..

```
<!-- chmod 600 ssh-keys/swarm-cluster -->

### How to run Terraform and Ansible (manual setup)

### Automated setup
This Bash script automates the deployment of a full-stack application infrastructure using Terraform and Ansible. It provisions and configures a VM instance in Azure using Terraform, then configures the VM with Ansible, and finally executes a set of Docker containers using Docker Compose.

```bash
# Ensure Terraform, Ansible, netcat (nc), and jq are installed.
# After running the command bellow you can follow the prompts and monitor the logs for deployment progress.
bash setup.sh

# Remember to destroy infrastructure after use
```

### How to run Terraform and Ansible

#### Running Terraform

```bash
# Go to terraform folder
$ cd terraform

# Run necessary terraform commands
$ terraform init
$ terraform plan
$ terraform apply -auto-approve
$ cd ..
```

#### Running Ansible

```bash
# Go to ansible folder
$ cd ansible

# Generate inventory file
$ bash create_hosts.sh

# Run playbook with verbosity
$ ansible-playbook -i inventory.ini playbook.yml -vvv

# Go back to main directory
$ cd ..
```

### :microscope: How to inspect the result

Inside the browser:

<p>http://public_ip</p>

#### Connect to the Virtual Machine using SSH (Linux/Mac):

```bash
# Connect to remote VM in the cloud (ssh azureadmin@11.111.111.11 -i ../ssh-keys/swarm-cluster)
$ ssh azureadmin@public_ip -i /path/to/your/private_key

# Verify if the containers are correctly being executed inside de VM
$ docker ps

# Disconnect from VM
$ exit # or press: ctrl + d
```

### Preview

<h1 align="center">
    <img 
      alt="Printscreen resultado do docker ps com terminal conectado na maquina virtual" src="./assets/containers_running_on_VM.png" width="940px"
    />
</h1>
<h1 align="center">
    <img alt="Vote application running on browser" src="./assets/az_front_vote_screen.png" width="940px"/>
</h1>
<h1 align="center">
    <img 
      alt="Vote application running on browser" 
      src="./assets/az_front_vote_screen_with_votes.png" 
      width="940px"
    />
</h1>

### Destroying Infrastructure with Terraform

```bash
# Navigate to the Terraform configuration directory
$ cd terraform

# If you haven't already done so, initialize Terraform
$ terraform init

# Optional step to preview the changes Terraform will make to destroy the infrastructure
$ terraform plan -destroy

# Perform the destruction of resources. Terraform will prompt you to confirm this operation
$ terraform destroy
```

### Acknowledgment

This Infrastructure as Code (IaC) exercise is built upon an Azure Sample showcasing a comprehensive full stack application called [Azure Voting App](https://github.com/Azure-Samples/azure-voting-app-redis.git).

### :page_facing_up: License

This project is under the MIT license.

### :mailbox_with_mail: Get in touch!

[LinkedIn](https://www.linkedin.com/in/diegojurfest/)

### Thats it ! :wave:

---

by Diego Jurfest :tada:

<!-- <div align="left">
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/javascript/javascript-original.svg" height="40" alt="javascript logo"  />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/typescript/typescript-original.svg" height="40" alt="typescript logo"  />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/docker/docker-original.svg" height="40" alt="react logo"  />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/azure/azure-plain.svg" height="40" alt="azure logo"  />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/redis/redis-original.svg" height="40" alt="redis logo"  />
  <img width="12" />
</div>

###

<div align="center">
  <a href="https://angular.io/">
    <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/angularjs/angularjs-original.svg" height="30" width="42" alt="angularjs logo"  />
  </a>
  <a href="https://nx.dev/">
    <img src="https://raw.githubusercontent.com/nrwl/nx/master/images/nx-logo.png" width="42" alt="nx logo">
  </a>
  <a href="https://tailwindcss.com/">
    <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/tailwindcss/tailwindcss-plain.svg" height="30" width="42" alt="tailwindcss logo"  />
  </a>
  <a href="https://storybook.js.org/">
    <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/storybook/storybook-original.svg" height="30" width="42" alt="storybook logo"  />
  </a>
  <a href="https://www.figma.com/design/">
    <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/figma/figma-original.svg" height="30" width="42" alt="figma logo"  />
  </a>
</div>

### -->

<!-- TODO:
- Refactor playbook with roles (making the playbook more modular, reusable and simple to maintain)
- Add alternative branch with AWS as cloud provider
- Add alternative branch fetching vote-app from remote repository
_ Use "terraform graph" and a third party tool (like Graphviz) to respectively generate graph and transform .DOT file to image format
-->
