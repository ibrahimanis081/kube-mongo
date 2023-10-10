<!-- PROJECT TITLE AND LOGO -->
<br />
<div align="center">
  
   <h3 align="center">Setting up MongoDB On Kubernetes</h3>

[![kube-mongo.png](https://i.postimg.cc/yNJJpjdW/kube-mongo.png)](https://postimg.cc/jWbdLzyr)
</div>



<!-- ABOUT THE PROJECT -->
## About The Project

This repository contains the configuration files and instructions to set up a MongoDB deployment in a Kubernetes cluster, secured with secrets for username and password, and a Mongo Express deployment to easily manage and interact with the database. Additionally, the Mongo Express service is exposed using a LoadBalancer to allow external access to the MongoDB database.

### Built With
<br/>

* ![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)

* ![MongoDB](https://img.shields.io/badge/MongoDB-%234ea94b.svg?style=for-the-badge&logo=mongodb&logoColor=white)

* ![Linode](https://img.shields.io/badge/linode-00A95C?style=for-the-badge&logo=linode&logoColor=white)

## Getting Started

### Prerequisites 

* Kubectl installed
* Personal Access Token for linode account, can be generated at <https://cloud.linode.com/profile/tokens> by clicking "Add a Personal Access Token".

* Set Linode Personal Access Token as an environment variable:

    ```bash
    export TF_VAR_linode_token="Put Your Linode Token Here"
    ```

### Deployment Steps
#### 1. Clone the repo
```bash
 git clone https://github.com/ibrahimanis081/kube-mongo.git
```
#### 2. Provision Kubernetes cluster
From the `linode_kubernetes_engine` directory, run:
```bash 
terraform init
terraform apply
```
The full set of provisioning should be completed in under 5 minutes.
A kubernetes configuration file called `config` is generated and copied to `~/.kube/` directory for kubectl to access the cluster

Confirm it's properly set up by running
 ``` bash 
 kubectl get node
 ```
 The list of worker nodes in the cluster should be displayed.

#### 3. Configure Secrets
Create Kubernetes Secrets for storing the MongoDB username and password securely.

a. Credentials are base64 encoded. Replace `mongodb-username` and `mongodb-password` with your actual credentials.
```bash
echo -n 'mongodb-username' | base64

echo -n 'mongodb-password' | base64
```
b. Copy the encoded username and password to `secret.yaml`
[![username-and-password.png](https://i.postimg.cc/05MCnxRv/username-and-password.png)](https://postimg.cc/14S6Rk37)

c. Create the Secret
```bash
kubectl apply -f secret.yaml 
```
#### 4. Deploy MongoDB and its Service
Service Provides a fixed IP that allows other applications within the Kubernetes cluster to access the MongoDB instance. This enables consistent and reliable communication with the database regardless of pod IP changes.
```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```
#### 5. Create ConfigMap
Create a ConfigMap to store the MongoDB server URL. This allows you to centralize the configuration, other applications in the cluster can also access the url and make it easier to update when needed
```bash
kubectl apply -f configmap.yaml 
```
#### 6. Deploy Mongo Express
```bash
kubectl apply -f mongo-express-deployment.yaml 
```
#### 7. Expose Mongo Express
Expose the Mongo Express service externally using a LoadBalancer. This will allow you to access the MongoDB management interface from outside the cluster.
```bash
kubectl apply -f loadbalancer.yaml 
```
### Accessing MongoDB
You can access your MongoDB instance from within the Kubernetes cluster using the following connection URL:
```
mongodb://mongodb-service:27017
```
### Accessing Mongo Express
Access the Mongo Express web interface by finding the external IP address of the LoadBalancer service you created in step 7. 
you can verify using this command:
```
kubectl describe service mongo-express-loadbalancer
```
You should see the external IP and Port from the Output: 
[![describe-loadbalancer.png](https://i.postimg.cc/BbKbWjSx/describe-loadbalancer.png)](https://postimg.cc/rRqMxFtm)

Use the following URL in your web browser:
```
http://EXTERNAL_IP:8081

```
[![mongo-express-dashboard.png](https://i.postimg.cc/X7Wy50nQ/mongo-express-dashboard.png)](https://postimg.cc/t7rT0wZx)

## Cleanup
To delete the deployed resources, use the following commands:
```bash
kubectl delete -f deployment.yaml
kubectl delete -f mongo-express-deployment.yaml
kubectl delete -f secret.yaml
kubectl delete -f service.yaml
kubectl delete -f configmap.yaml
kubectl delete -f loadbalancer.yaml
```
From the `linode_kubernetes_engine`, Use this command this command to destroy the cluster on linode
```bash
terraform destroy -auto-approve 
```
## To-Do:
* Use a `StatefulSet` instead of `Deployment` for production-grade MongoDB deployments in Kubernetes.
* Implement monitoring using Prometheus and Grafana.