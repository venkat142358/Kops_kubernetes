#!/bin/bash

# List of services you want to restart
services=("asset" "audio" "auth" "episode" "episode-activity" "existing-http" "existing-messenger" "genre" "show" "user")

# Initialize an empty list of pods
pods_to_delete=()

# For each service, add all pods with a name that contains the service name to the list
for service in "${services[@]}"; do
  pods=$(kubectl get pods | grep $service | awk '{print $1}')
  
  if [ -n "$pods" ]; then
    echo "Adding pods for $service to the list for deletion"
    pods_to_delete+=($pods)
  else
    echo "No pods found for $service"
  fi
done

# If there are any pods to delete, delete them all at once
if [ ${#pods_to_delete[@]} -gt 0 ]; then
  echo "Deleting pods: ${pods_to_delete[@]}"
  kubectl delete pod "${pods_to_delete[@]}"
else
  echo "No pods to delete"
fi
