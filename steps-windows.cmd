az login
az account set --subscription <<replace subscriptionid>>
az group create --name aksfarmerswindows --location "southeastasia"

az ad sp create-for-rbac --skip-assignment -n "farmersappwindows" 

az aks create --resource-group aksfarmerswindows --name farmersaksclusterwin --node-count 1 --enable-addons monitoring --generate-ssh-keys --windows-admin-username "<<replace username>>" --windows-admin-password "<replace password>" --vm-set-type VirtualMachineScaleSets --network-plugin azure --verbose



az aks nodepool add --resource-group aksfarmerswindows --cluster-name farmersaksclusterwin --os-type Windows --name farwin --node-count 1 --verbose

az aks install-cli

az aks get-credentials -n farmersaksclusterwin -g aksfarmerswindows

kubectl get nodes

kubectl create secret generic filesharesecret --from-literal=azurestorageaccountname=<<replace storage account name>> --from-literal=azurestorageaccountkey=<<replace storage account key>>

# create the file containing deployment script

kubectl apply -f ~/cowin/deployment-windows.yaml

kubectl describe pods

kubectl exec -it farmers-deployment-5bc775989c-vkmdm cmd
# go to C:\ to find the fileshare

# upload a file in fileshare
kubectl exec deployment-azurestorage-test-5494d5c754-dqqgd -- ls ./myawesomefileshare/farmer1