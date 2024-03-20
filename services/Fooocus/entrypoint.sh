#!/bin/bash

set -Eeuo pipefail

mkdir -vp /data/config/Fooocus/

declare -A MOUNTS

MOUNTS["/root/.cache"]="/data/.cache"
MOUNTS["${ROOT}/input"]="/data/config/Fooocus/input"
MOUNTS["${ROOT}/output"]="/output/Fooocus"

MOUNTS["${ROOT}/models/upscale_models"]="/data/models/upscale_models"
MOUNTS["${ROOT}/models/inpaint"]="/data/models/inpaint"
MOUNTS["${ROOT}/models/clip_vision"]="/data/models/clip_vision"
MOUNTS["${ROOT}/models/prompt_expansion/fooocus_expansion"]="/data/models/prompt_expansion/fooocus_expansion"


for to_path in "${!MOUNTS[@]}"; do
  set -Eeuo pipefail
  from_path="${MOUNTS[${to_path}]}"
  rm -rf "${to_path}"
  if [ ! -f "$from_path" ]; then
    mkdir -vp "$from_path"
  fi
  mkdir -vp "$(dirname "${to_path}")"
  ln -sT "${from_path}" "${to_path}"
  echo Mounted $(basename "${from_path}")
done

if [ -f "/data/config/Fooocus/startup.sh" ]; then
  pushd ${ROOT}
  . /data/config/Fooocus/startup.sh
  popd
fi

git config --global --add safe.directory '*'

exec "$@"
