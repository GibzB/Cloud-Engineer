#!/bin/bash

# Set the name of the resource group to delete
resource_group_name="datadog-testing-test-rg"

# Prompt the user for confirmation
read -p "Are you sure you want to delete the resource group '$resource_group_name' and all its contents? This action is irreversible. (yes/no): " confirm

# Check the user's response
if [[ "$confirm" == "yes" ]]; then
  echo "Deleting resource group '$resource_group_name'..."
  az group delete --name "$resource_group_name" --yes
  if [ $? -eq 0 ]; then
    echo "Successfully deleted resource group '$resource_group_name'."
  else
    echo "Error occurred while deleting the resource group."
  fi
else
  echo "Deletion of resource group '$resource_group_name' cancelled."
fi

exit 0