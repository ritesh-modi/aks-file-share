az login
az account set --subscription <<replace with subscription is>>
az group create --name aksfarmers --location "southeastasia"

az ad sp create-for-rbac --skip-assignment -n "farmersapp" 

az aks create -g aksfarmers --location "southeastasia" -n farmersakscluster --node-count 1 --load-balancer-sku basic --vm-set-type AvailabilitySet --network-plugin azure --service-principal <<replace with service principal id>> --client-secret <<replace with client_secret>> --verbose

az aks install-cli

az aks get-credentials -n farmersakscluster -g aksfarmers

kubectl get nodes

kubectl create secret generic filesharesecret --from-literal=azurestorageaccountname=<<replace storage account name>> --from-literal=azurestorageaccountkey=<<replace storage account key>>

# create the file containing deployment script

kubectl apply -f ~/cowin/deployment.yaml

kubectl describe pods

kubectl exec deployment-azurestorage-test-5494d5c754-dqqgd -- ls ./myawesomefileshare/farmers1
# upload a file in fileshare
kubectl exec deployment-azurestorage-test-5494d5c754-dqqgd -- ls ./myawesomefileshare/farmer1