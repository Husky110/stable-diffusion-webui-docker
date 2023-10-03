echo "Installing local-persist driver to docker."
curl -fsSL https://raw.githubusercontent.com/MatchbookLab/local-persist/master/scripts/install.sh | sudo bash
echo "Running download-container to get all requirements"
docker compose --profile download up --build
