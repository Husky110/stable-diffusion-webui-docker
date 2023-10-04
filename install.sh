#!/bin/bash

if [ ! -f /usr/bin/docker-volume-local-persist ]; then
  echo "Installing local-persist driver to docker (will ask you for your root-password!)..."
  wget -O docker-volume-local-persist https://github.com/MatchbookLab/local-persist/releases/download/v1.3.0/local-persist-linux-amd64
  sudo chmod +x docker-volume-local-persist
  sudo mv docker-volume-local-persist /usr/bin/docker-volume-local-persist
fi
if [ ! -f /etc/systemd/docker-volume-local-persist.service ]; then
  wget -O docker-volume-local-persist.service https://raw.githubusercontent.com/MatchbookLab/local-persist/master/init/systemd.service
  sudo mv docker-volume-local-persist.service /etc/systemd/system/docker-volume-local-persist.service
  sudo systemctl daemon-reload
  sudo systemctl enable docker-volume-local-persist
  sudo systemctl start docker-volume-local-persist
fi
echo "Creating required folder-structure..."
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

read -p "Have you read and setup the .env-file? (yes/no) " yn

case $yn in
	yes ) echo ok, we will proceed;;
	no ) echo exiting...;
		exit;;
	* ) echo invalid response;
		exit 1;;
esac

#echo "Running download-container to get all requirements..."
#docker compose --profile download up --build
