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
#echo "Running download-container to get all requirements..."
#docker compose --profile download up --build
