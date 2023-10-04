#!/bin/bash
if [ ! -f .env ]; then
  cp .env.default .env
fi
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
  ./data/models/Facedetectors \
  ./data/models/LDSR \
  ./data/models/SwinIR \
  ./data/models/VAE-approx \
  ./data/models/karlo \
  ./data/models/VAE \
  ./output/auto
echo "Step 1 is done..."
echo "In Step 2 we will setup your environment..."
echo "Step 2 - You can leave your .env-file on default values if you like."
echo "Step 2 - But I highly recommend that you at least go through it!"
read -p "Step 2 - Have you gone through the .env-file and modified it to your likings? (yes/no) " yn
case $yn in
	yes ) echo ok, we will proceed;;
	no ) echo exiting...;
		exit;;
	* ) echo invalid response;
		exit 1;;
esac
echo "Step 3 - We will download everything needed..."
echo "This is the last step and will take some time!"

echo "Running download-container to get all requirements..."
docker compose --profile download up --build
echo "If the last line was 'exited with code 0' you are done installing. If not - well... Have fun figuring out your error. :)"
