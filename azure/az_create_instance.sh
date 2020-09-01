az group create --name web --location westus2
az vm create --resource-group web --name web --image Debian --generate-ssh-keys --output json
az group delete --name web
