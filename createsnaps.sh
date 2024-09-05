#!/bin/bash

# Set cloudmonkey profile and session
cloudmonkey set profile <your-profile>
cloudmonkey sync

# Path to the file containing only VM IDs
VM_LIST_FILE="vm_list.txt"

# Specify a single snapshot name to be used for all VMs
SNAPSHOT_NAME="your-snapshot-name"

# Read the file line by line
while read -r VM_ID; do
  # Create a snapshot for the VM
  echo "Creating snapshot '$SNAPSHOT_NAME' for VM '$VM_ID'..."
  cloudmonkey create snapshot virtualmachineid="$VM_ID" name="$SNAPSHOT_NAME"
done < "$VM_LIST_FILE"
