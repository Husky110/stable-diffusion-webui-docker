#!/usr/bin/env bash

set -Eeuo pipefail

echo "Downloading, this might take a while..."

DOWNLOAD_CONTROLNET_ANNOTATORS= $([ "$A1111_INSTALL_RECOMMENDED_EXTENSION_CONTROLNET" == "1" ] && 1 || 0)

if [ "$INSTALL_DOWNLOAD_BASE_MODELS" == "1" ]
then
  echo "Downloading SD-1.5-Basemodels..."
  aria2c -x 10 --disable-ipv6 --input-file /docker/downloadlists/checkpoints.download --dir /data/checkpoints --continue
  echo "Checking SHAs for SD-1.5-Basemodels..."
  parallel --will-cite -a /docker/downloadlists/checkpoints.sha256 "echo -n {} | sha256sum -c"
fi

if [ "$INSTALL_DOWNLOAD_BASE_VAE" == "1" ]
then
  echo "Downloading Base-VAEs..."
  aria2c -x 10 --disable-ipv6 --input-file /docker/downloadlists/vae.download --dir /data/VAE --continue
  echo "Checking SHAs for Base-VAEs..."
  parallel --will-cite -a /docker/downloadlists/vae.sha256 "echo -n {} | sha256sum -c"
fi

if [ "$DOWNLOAD_CONTROLNET_ANNOTATORS" == "1" ]
then
  echo "Downloading ControlNet-Models..."
  aria2c -x 10 --disable-ipv6 --input-file /docker/downloadlists/controlnet.download --dir /data/ControlNet --continue
  #echo "Checking SHAs for Base-VAEs..."
  #parallel --will-cite -a /docker/downloadlists/vae.sha256 "echo -n {} | sha256sum -c"
fi



echo "Downloading Base-Upscalers..."
aria2c -x 10 --disable-ipv6 --input-file /docker/downloadlists/upscalers.download --dir /data --continue
echo "Checking SHAs for Base-Upscalers..."
parallel --will-cite -a /docker/downloadlists/upscalers.sha256 "echo -n {} | sha256sum -c"
echo "Downloading A1111-Requirements..."
aria2c -x 10 --disable-ipv6 --input-file /docker/downloadlists/a1111-requirements.download --dir /data --continue
echo "Checking SHAs for A1111-Requirements..."
parallel --will-cite -a /docker/downloadlists/a1111-requirements.sha256 "echo -n {} | sha256sum -c"
echo "Downloading Basic-FaceRestore-Requirements..."
aria2c -x 10 --disable-ipv6 --input-file /docker/downloadlists/facerestore.download --dir /data --continue
echo "Checking SHAs for Basic-FaceRestore-Requirements..."
parallel --will-cite -a /docker/downloadlists/facerestore.sha256 "echo -n {} | sha256sum -c"

cat <<EOF
By using this software, you agree to the following licenses:
https://github.com/AbdBarho/stable-diffusion-webui-docker/blob/master/LICENSE
https://github.com/CompVis/stable-diffusion/blob/main/LICENSE
https://github.com/AUTOMATIC1111/stable-diffusion-webui/blob/master/LICENSE.txt
https://github.com/invoke-ai/InvokeAI/blob/main/LICENSE
And licenses of all UIs, third party libraries, and extensions.
EOF
