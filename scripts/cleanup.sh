#!/bin/bash

# Remove all unused Docker images
if command -v docker &> /dev/null
then
    echo "Pruning Docker images..."
    docker system prune -f || { echo "Error: Failed to prune Docker images"; exit 1; }
else
    echo "Docker not found. Skipping Docker cleanup."
fi

# Clean up old logs
echo "Cleaning up old logs..."
find /var/log -type f -name "*.log" -exec rm -f {} \; || { echo "Error: Failed to clean up logs"; exit 1; }

echo "Cleanup completed."
