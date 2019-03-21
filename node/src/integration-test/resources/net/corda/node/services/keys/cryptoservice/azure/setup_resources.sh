function prepareResources() 
{
	working_directory=$(pwd)

	resourceGroup=testResourceGroup-$USER
	echo "Creating resource group: $resourceGroup ..."
	az group create --name $resourceGroup --location westeurope

	echo "Creating a standard key vault ..."
	az keyvault create --name standard-corda-keyvault \
			--resource-group $resourceGroup \
			--sku standard

	echo "Creating a premium key vault ..."
	az keyvault create --name premium-corda-keyvault \
			--resource-group $resourceGroup \
			--sku premium

	echo "Creating a service principal ..."
	output=$(az ad sp create-for-rbac --name http://MyServicePrincipal --create-cert)
	client_id=$(echo $output | jq -r .appId)
	pem_file=$(echo $output | jq -r .fileWithCertAndPrivateKey)

	echo "Creating policies for key vault access from the service principal ..."
	az keyvault set-policy --name 'standard-corda-keyvault' --spn $client_id --key-permissions sign create get
	az keyvault set-policy --name 'premium-corda-keyvault' --spn $client_id --key-permissions sign create get

	echo "Creating pkcs12 file and copying it in the resources folder"
	openssl pkcs12 -export -out $working_directory/out.pkcs12 -in $pem_file -name 1 -passout pass:

	echo "The client id is: $client_id"
}

prepareResources