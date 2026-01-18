#!/bin/bash

# Check if mkdocs is installed
if ! command -v mkdocs &> /dev/null
then
    echo "mkdocs not found. Installing..."
    pip3 install mkdocs || { echo "Error: Failed to install mkdocs"; exit 1; }
fi

# Build and deploy the site
echo "Deploying to GitHub Pages..."
mkdocs gh-deploy --force || { echo "Error: Failed to deploy to GitHub Pages"; exit 1; }

echo "Deployment completed successfully."
