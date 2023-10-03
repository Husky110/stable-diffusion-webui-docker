#!/usr/bin/env bash

set -Eeuo pipefail

# EX_TODO: maybe just use the .gitignore file to create all of these -> or maybe not... leaving that here is okay, cause then others can add to their structure aswell.

# shamelessly creating a manageable substructure here...
mkdir -vp /data/models/Stable-diffusion \
  /data/models/Lora \
  /data/models/hypernetworks \
  /data/models/ControlNet \
  /data/models/ESRGAN \
  /data/models/Embeddings \
  /data/models/GFPGAN \
  /data/models/RealESRGAN \
  /data/models/LDSR \
  /data/models/SwinIR \
  /data/models/VAE-approx \
  /data/models/karlo \
  /data/models/VAE

echo "Downloading, this might take a while..."

aria2c -x 10 --disable-ipv6 --input-file /docker/links.txt --dir /data/models --continue

echo "Checking SHAs..."

parallel --will-cite -a /docker/checksums.sha256 "echo -n {} | sha256sum -c"

cat <<EOF
By using this software, you agree to the following licenses:
https://github.com/AbdBarho/stable-diffusion-webui-docker/blob/master/LICENSE
https://github.com/CompVis/stable-diffusion/blob/main/LICENSE
https://github.com/AUTOMATIC1111/stable-diffusion-webui/blob/master/LICENSE.txt
https://github.com/invoke-ai/InvokeAI/blob/main/LICENSE
And licenses of all UIs, third party libraries, and extensions.
EOF
