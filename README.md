# kubeedge-cluster-gcp

### Infrastructure Diagram
![GCP Infrastructure Diagram](img/architecture-kubeEdge-cluster.png)

### Steps to deploy the cluster
1. Create an account on Google Cloud Platform and create a project. This project is where all the infrastructure resources will be created.
2. Go to the [service account key page in the Cloud Console](https://console.cloud.google.com/apis/credentials/serviceaccountkey) and create a new service account with Project -> Owner role. Download the credentials file in JSON format.
3. Enable the GCP APIs: Storage, Compute Engine, VPC, IAM. If you're enabling the APIs for the first time, wait ~20-30 minutes before applying Terraform. The GCP API activation does not take immediate effect.
4. Clone this repo 
```
git clone https://github.com/itselavia/kubeedge-cluster-gcp
```
5. cd into the repository
6. Edit the file named “terraform.tfvars” with the following required parameters:
    1. region: the GCP region where all the resources will be created
    2. vpc_name: the name for the virtual private cloud network
    3. zone: the GCP zone where all the resources will be created. The zone must be in the same region as declared in step 6.1
    4. project_name: name of the GCP project which was created in step 1
    5. k8s_worker_node_count: number of worker nodes to be created for the Kubernetes cluster
    6. edge_node_count: number of edge nodes to be created for the KubeEdge cluster
    7. credentials_file_location: path to the JSON credentials file downloaded in Step 2 <br>
- Example terraform.tfvars file:
```
region                    = "us-west2"
vpc_name                  = "kubeedge-infra"
zone                      = "us-west2-a"
project_name              = "deploy-kubeedge-gcp"
k8s_worker_node_count     = 1
edge_node_count           = 1
credentials_file_location = "~/Downloads/deploy-kubeedge-gcp-19242787b5a4.json"
```
7. Install Terraform by following the steps mentioned in the [official documentation](https://learn.hashicorp.com/tutorials/terraform/install-cli)
8. Run ```terraform init``` to initialize the and import the Terraform modules into the working directory
9. Run ```terraform plan``` to view all the infrastructure components Terraform will create in Google Cloud
10. Run ```terraform apply --auto-approve``` which will start creating the cluster infrastructure on GCP.
11. The kubeconfig file for the Kubernetes cluster is downloaded to modules/kubernetes/config. Run the following command to setup KUBECONFIG
```
export KUBECONFIG=`pwd`/modules/kubernetes/config
```
12. Run ```kubectl get nodes``` to see the worker nodes and edge nodes of the cluster
13. If the nodes are not visible, it’s possible that the cluster setup is still in progress. To view the logs for cluster setup, ssh into the node via the GCP Virtual Machines UI, and tail the /var/log/user-data.log file on any node.
14. If you want to add or remove any nodes from the existing cluster, simply edit the “terraform.tfvars” file with desired values for variables ```k8s_worker_node_count``` or/and ```edge_node_count``` and run ```terraform apply --auto-approve```