#!/bin/bash

set -Eeuo pipefail

# Set up config file
#python /docker/config.py /data/auto/config/config.json <- I'm leaving config.py intact in case we need it again later

if [ ! -f /data/auto/config/ui-config.json ]; then
  echo '{}' > /data/auto/config/ui-config.json
fi

if [ ! -f /data/auto/config/styles.csv ]; then
  touch /data/auto/config/styles.csv
fi

#running initalization
if [ ! -f /data/auto/docker-init-complete ]; then
  echo "Initializing..."
  cp /docker/default-config.json /data/auto/config/config.json
  cd ${ROOT}
  #initialize a symlink for the embeddings
  rm -rf embeddings && ln -s /data/models/Embeddings embeddings

  # extensions...
  if [ ! -d /data/auto/extensions ]; then
      mkdir /data/auto/extensions
  fi
  rm -rf extensions && ln -s /data/auto/extensions extensions
  #adding recommended extensions
  if [ ! -d /data/auto/extensions/sd-webui-controlnet ]; then
        cp -rf ${ROOT}/repositories/sd-webui-controlnet /data/auto/extensions/sd-webui-controlnet
  fi
  if [ ! -d /data/auto/extensions/multidiffusion-upscaler-for-automatic1111 ]; then
      cp -rf ${ROOT}/repositories/multidiffusion-upscaler-for-automatic1111 /data/auto/extensions/multidiffusion-upscaler-for-automatic1111
  fi
  if [ ! -d /data/auto/extensions/sd-webui-regional-prompter ]; then
      cp -rf ${ROOT}/repositories/sd-webui-regional-prompter /data/auto/extensions/sd-webui-regional-prompter
  fi

  ln -s /data/auto/config/config.json config.json
  ln -s /data/auto/config/ui-config.json ui-config.json
  ln -s /data/auto/config/styles.csv styles.csv

  #Codeformer
  if [ ! -d ${ROOT}/repositories/CodeFormer/weights/facelib ]; then
    mkdir -p ${ROOT}/repositories/CodeFormer/weights/facelib
  else
    rm -rf /codeformer_facelib/*
    mv -v ${ROOT}/repositories/CodeFormer/weights/facelib /codeformer_facelib
    rm -rf ${ROOT}/repositories/CodeFormer/weights/facelib
  fi
  ln -s /codeformer_facelib ${ROOT}/repositories/CodeFormer/weights/facelib
  #finalizing
  touch /data/auto/docker-init-complete
fi

echo "Installing extension dependencies (if any)"

shopt -s nullglob
# For install.py, please refer to https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Developing-extensions#installpy
list=(./extensions/*/install.py)
for installscript in "${list[@]}"; do
  EXTNAME=`echo $installscript | cut -d '/' -f 3`
  # Skip installing dependencies if extension is disabled in config
  if `jq -e ".disabled_extensions|any(. == \"$EXTNAME\")" ${ROOT}/config.json`; then
    echo "Skipping disabled extension ($EXTNAME)"
    continue
  fi
  PYTHONPATH=${ROOT} python "$installscript"
done

if [ -f "/data/auto/config/startup.sh" ]; then
  pushd ${ROOT}
  echo "Running startup script"
  . /data/auto/config/startup.sh
  popd
fi
rm -rf /output/temp/auto/*.*
exec "$@"
