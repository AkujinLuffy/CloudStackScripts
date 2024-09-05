#!/bin/bash

# Set cloudmonkey profile and session
cloudmonkey set profile <your-profile>
cloudmonkey sync

# Path to the file containing VM IDs
VM_LIST_FILE="vm_list.txt"

# Specify the snapshot name prefix used when creating the snapshots
SNAPSHOT_NAME_PREFIX="your-snapshot-name"

# Read the file line by line
while read -r VM_ID; do
  # List snapshots for the VM and filter by name
  SNAPSHOT_IDS=$(cloudmonkey list snapshots virtualmachineid="$VM_ID" filter=id,name | grep -A1 "$SNAPSHOT_NAME_PREFIX" | grep 'id = ' | awk '{print $3}')

  if [ -z "$SNAPSHOT_IDS" ]; then
    echo "No snapshots with name prefix '$SNAPSHOT_NAME_PREFIX' found for VM ID: $VM_ID"
    continue
  fi

  # Iterate over each snapshot ID and delete it
  for SNAPSHOT_ID in $SNAPSHOT_IDS; do
    echo "Deleting snapshot ID: $SNAPSHOT_ID for VM ID: $VM_ID with name prefix '$SNAPSHOT_NAME_PREFIX'..."
    cloudmonkey delete snapshot id="$SNAPSHOT_ID"
  done
done < "$VM_LIST_FILE"
