#!/usr/bin/env bash

set -Eeuo pipefail

echo "Downloading, this might take a while..."

if [ "$INSTALL_DOWNLOAD_BASE_MODELS" == "1" ]
then
  echo "Downloading SD-1.5-Basemodels..."
  aria2c -x 10 --disable-ipv6 --input-file /docker/downloadlists/checkpoints.download --dir /data/models --continue
fi

if [ "$INSTALL_DOWNLOAD_BASE_VAE" == "1" ]
then
  echo "Downloading Base-VAEs..."
  aria2c -x 10 --disable-ipv6 --input-file /docker/downloadlists/vae.download --dir /data/VAE --continue
fi

if [ "$INSTALL_DOWNLOAD_BASE_UPSCALERS" == "1" ]
then
  echo "Downloading Base-Upscalers..."
  aria2c -x 10 --disable-ipv6 --input-file /docker/downloadlists/upscalers.download --dir /data --continue
fi

if [ "$INSTALL_A1111_REQUIREMENTS" == "1" ]
then
  echo "Downloading A1111-Requirements..."
  aria2c -x 10 --disable-ipv6 --input-file /docker/downloadlists/a1111-requirements.download --dir /data --continue
fi

echo "Checking SHAs..."

if [ "$INSTALL_DOWNLOAD_BASE_MODELS" == "1" ]
then
  echo "Checking SHAs for SD-1.5-Basemodels..."
  parallel --will-cite -a /docker/downloadlists/checkpoints.sha256 "echo -n {} | sha256sum -c"
fi

if [ "$INSTALL_DOWNLOAD_BASE_VAE" == "1" ]
then
  echo "Checking SHAs for Base-VAEs..."
  parallel --will-cite -a /docker/downloadlists/vae.sha256 "echo -n {} | sha256sum -c"
fi

if [ "$INSTALL_DOWNLOAD_BASE_UPSCALERS" == "1" ]
then
  echo "Checking SHAs for Base-Upscalers..."
  parallel --will-cite -a /docker/downloadlists/upscalers.sha256 "echo -n {} | sha256sum -c"
fi

if [ "$INSTALL_A1111_REQUIREMENTS" == "1" ]
then
  echo "Checking SHAs for A1111-Requirements..."
  parallel --will-cite -a /docker/downloadlists/a1111-requirements.sha256 "echo -n {} | sha256sum -c"
fi

cat <<EOF
By using this software, you agree to the following licenses:
https://github.com/AbdBarho/stable-diffusion-webui-docker/blob/master/LICENSE
https://github.com/CompVis/stable-diffusion/blob/main/LICENSE
https://github.com/AUTOMATIC1111/stable-diffusion-webui/blob/master/LICENSE.txt
https://github.com/invoke-ai/InvokeAI/blob/main/LICENSE
And licenses of all UIs, third party libraries, and extensions.
EOF
