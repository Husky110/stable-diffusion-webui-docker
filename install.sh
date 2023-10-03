if[ ! -f /usr/bin/docker-volume-local-persist ]; then
  echo "Installing local-persist driver to docker (will ask you for your root-password!)..."
  wget https://github.com/MatchbookLab/local-persist/releases/download/v1.3.0/local-persist-linux-amd64
  sudo chmod +x local-persist-linux-amd64
  sudo mv local-persist-linux-amd64 /usr/bin/docker-volume-local-persist
fi
if[ ! -f /etc/systemd/docker-volume-local-persist.service ]; then
  wget https://github.com/MatchbookLab/local-persist/blob/master/init/systemd.service
  sudo mv systemd.service /etc/systemd/docker-volume-local-persist.service
  sudo systemctl daemon-reload
  sudo systemctl enable docker-volume-local-persist
  sudo systemctl start docker-volume-local-persist
fi
#echo "Running download-container to get all requirements..."
#docker compose --profile download up --build
