#!/bin/bash

set -Eeuo pipefail

# Set up config file
#python /docker/config.py /data/configs/config.json <- I'm leaving config.py intact in case we need it again later

if [ ! -f /data/configs/ui-config.json ]; then
  echo '{}' > /data/configs/ui-config.json
fi

if [ ! -f /data/configs/styles.csv ]; then
  touch /data/configs/styles.csv
fi

if [ ! -f /data/configs/config.json ]; then
  cp /data/configs/repo-default-config.json /data/configs/config.json
fi

#running initalization
if [ ! -f ${ROOT}/docker-init-complete ]; then
  echo "Initializing..."
  mkdir -p /output/temp
  cd ${ROOT}

  #adding recommended extensions
  if [ "$A1111_INSTALL_RECOMMENDED_EXTENSION_CONTROLNET" == "1" ]
  then
    if [ ! -d /data/auto/extensions/sd-webui-controlnet ]; then
          cp -rf ${ROOT}/repositories/sd-webui-controlnet ${ROOT}/extensions/sd-webui-controlnet
    fi
  fi
  if [ "$A1111_INSTALL_RECOMMENDED_EXTENSION_CONTROLNET" == "1" ]
    then
    if [ ! -d /data/auto/extensions/multidiffusion-upscaler-for-automatic1111 ]; then
        cp -rf ${ROOT}/repositories/multidiffusion-upscaler-for-automatic1111 ${ROOT}/extensions/multidiffusion-upscaler-for-automatic1111
    fi
  fi
  if [ "$A1111_INSTALL_RECOMMENDED_EXTENSION_CONTROLNET" == "1" ]
    then
    if [ ! -d /data/auto/extensions/sd-webui-regional-prompter ]; then
        cp -rf ${ROOT}/repositories/sd-webui-regional-prompter ${ROOT}/extensions/sd-webui-regional-prompter
    fi
  fi

  ln -s /data/configs/config.json config.json
  ln -s /data/configs/ui-config.json ui-config.json
  ln -s /data/configs/styles.csv styles.csv

  #finalizing
  touch ${ROOT}/docker-init-complete
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

if [ -f "/data/configs/startup.sh" ]; then
  pushd ${ROOT}
  echo "Running startup script"
  . /data/configs/startup.sh
  popd
fi
rm -rf /output/temp/auto/*.*
exec "$@"
