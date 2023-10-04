#!/bin/bash
sed -i -e "s|!REPLACEWITHPROJECTPATH!|$PWD|g" .env #this has to be done, otherwise docker uses the wrong volume-paths and fails.
echo "This script will guide you through the installation-process."
echo "Step 1 - We creating required folder-structure in the project-root..."
mkdir -vp ./data/models/Checkpoints \
  ./data/models/Lora \
  ./data/models/Hypernetworks \
  ./data/models/ControlNet \
  ./data/models/Codeformer \
  ./data/models/ESRGAN \
  ./data/models/Embeddings \
  ./data/models/GFPGAN \
  ./data/models/RealESRGAN \
  ./data/models/LDSR \
  ./data/models/SwinIR \
  ./data/models/VAE-approx \
  ./data/models/karlo \
  ./data/models/VAE
echo "Step 1 is done..."
echo "Step 2 - We will download everything needed..."
echo "This is the last step and will take some time!"
read -p "Have you read and setup the .env-file? (yes/no) " yn

case $yn in
	yes ) echo ok, we will proceed;;
	no ) echo exiting...;
		exit;;
	* ) echo invalid response;
		exit 1;;
esac

echo "Running download-container to get all requirements..."
docker compose --profile download up --build
