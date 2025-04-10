#!/bin/bash

# Set variables
resource_group="datadog-testing-test-rg" # Replace with your desired resource group name
location="eastus2" # Replace with your desired Azure region
windows_username="azureuser" # Replace with your desired Windows username
windows_password="YourSecurePassword123!" # Replace with a strong password
linux_username="azureuser" # Replace with your desired Linux username
linux_ssh_public_key_path="~/.ssh/id_rsa.pub" # Replace with the path to your SSH public key (optional)

# VM Names
vm_name_win1="vm-microsoft-1"
vm_name_win2="vm-microdoft-2"
vm_name_linux="vm-linux"

# Create the resource group if it doesn't exist
echo "Creating resource group: $resource_group in $location..."
az group create --name "$resource_group" --location "$location" --output table

# Create the first Windows VM: vm-microsoft-1
echo "Creating Windows VM: $vm_name_win1..."
az vm create \
  --resource-group "$resource_group" \
  --name "$vm_name_win1" \
  --location "$location" \
  --image "Win2019Datacenter" \
  --os-disk-size-gb 128 \
  --admin-username "$windows_username" \
  --admin-password "$windows_password" \
  --output table

# Create the second Windows VM: vm-microdoft-2
echo "Creating Windows VM: $vm_name_win2..."
az vm create \
  --resource-group "$resource_group" \
  --name "$vm_name_win2" \
  --location "$location" \
  --image "Win2019Datacenter" \
  --os-disk-size-gb 128 \
  --admin-username "$windows_username" \
  --admin-password "$windows_password" \
  --output table

# Create the Linux VM: vm-linux
echo "Creating Linux VM: $vm_name_linux..."
az vm create \
  --resource-group "$resource_group" \
  --name "$vm_name_linux" \
  --location "$location" \
  --image "Ubuntu2204" \
  --os-disk-size-gb 128 \
  --admin-username "$linux_username" \
  --generate-ssh-keys # This will generate SSH keys if you don't provide a public key
  # --ssh-key-value "$linux_ssh_public_key_path" # Uncomment this line and replace with your public key path if you have one
  --output table

echo "Successfully created the following VMs in resource group '$resource_group':"
echo "- $vm_name_win1"
echo "- $vm_name_win2"
echo "- $vm_name_linux"
echo ""
echo "You can now proceed with installing the Datadog agent on these VMs."