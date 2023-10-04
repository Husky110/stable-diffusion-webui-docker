#!/bin/bash
sed -i -e "s|!REPLACEWITHPROJECTPATH!|$PWD|g" .env #this has to be done, otherwise docker uses the wrong volume-paths and fails.
echo "This script will guide you through the installation-process."
echo "Step 1 - we will install the local-persist-plugin for docker..."
if [ ! -f /usr/bin/docker-volume-local-persist ]; then
  echo "Installing local-persist driver to docker (will ask you for your root-password!)..."
  wget -O docker-volume-local-persist https://github.com/MatchbookLab/local-persist/releases/download/v1.3.0/local-persist-linux-amd64
  sudo chmod +x docker-volume-local-persist
  sudo mv docker-volume-local-persist /usr/bin/docker-volume-local-persist
fi
if [ ! -f /etc/systemd/system/docker-volume-local-persist.service ]; then
  wget -O docker-volume-local-persist.service https://raw.githubusercontent.com/MatchbookLab/local-persist/master/init/systemd.service
  sudo mv docker-volume-local-persist.service /etc/systemd/system/docker-volume-local-persist.service
  sudo systemctl daemon-reload
  sudo systemctl enable docker-volume-local-persist
  sudo systemctl start docker-volume-local-persist
fi
echo "Step 1 is done..."
echo "Step 2 - We creating required folder-structure in the project-root..."
mkdir -vp ./data/models/Checkpoints \
  ./data/models/Lora \
  ./data/models/Hypernetworks \
  ./data/models/ControlNet \
  ./data/models/ESRGAN \
  ./data/models/Embeddings \
  ./data/models/GFPGAN \
  ./data/models/RealESRGAN \
  ./data/models/LDSR \
  ./data/models/SwinIR \
  ./data/models/VAE-approx \
  ./data/models/karlo \
  ./data/models/VAE
echo "Step 2 is done..."
echo "Step 3 - We will download everything needed..."
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
