# Kandula

* Kandula will make sure that you will know everything about your EC2 instances.
* Start, stop and scheduling EC2 instaces and health check to your AWS regions.

![kandula!](https://media.giphy.com/media/AUYhIMdGrg23e/giphy.gif)

# Prerequisites

Any linux mechine with:
  * [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
  * [AWS cli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) 
  * [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
# Variables
  * In `version.tf` file change the terraform backend to your s3 backet name
  * when apply - terraform will ask for a private key name to use, please enter exist PK name in your AWS account
  
# How to run

  * Run the following commands to start your Kandula environment on aws

  ```terraform init
  terraform validate
  terraform plan --out terraform.tfplan
  terraform apply terraform.tfplan
  ```
  
* access to the loadbalancer that Terraform create for you and start manage Consul on port 8500 and Jenkins on port 8080

* Configure Jenkins:
  * Install the following plugins:
    ``` Git plugin
    Pipeline
    Kubernetes continues deploy
    Docker
  * Configure your Github, Dockerhub and EKS credentials in jenkins
  
  
    to configure EKS credential you will need to run the following commands:
  
  ```
     aws eks --region=us-east-1 update-kubeconfig --name <cluster_name>
     kubectl get nodes -o wide 
  ```
     make sure you can see 4 ready nodes
     
     edit the following file (make the required changes):
     
 ``` apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: <Replace with ARN of your EKS nodes role>
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: arn:aws:iam::111122223333:role/eks_role 
      username: eks_role
      groups: 
        - system:masters
  mapUsers: |
    - userarn: <arn:aws:iam::111122223333:user/admin>
      username: <admin>
      groups:
        - <system:masters>
  ```
   push the configuration file to kubernetes:
   `kubectl apply -f <filename>.yaml`
     
  * Create new scm pipline with triger of 1 min to the following repo:
  [kandula repo](https://github.com/roee73/kandula_assignment)
  
  * Run the pipeline you just created
  
  Now kandula is avilable on eks loadbalncer, 
  
  the address of the load balancer is:
  ```kubectl get svc -o wide```
  
  
  ![kandula!](https://media.giphy.com/media/B5BP3OYgVN5ss/giphy.gif)
  

  
