#!/bin/bash

set -Eeuo pipefail

mkdir -vp /data/config/lora-scripts/

declare -A MOUNTS

MOUNTS["/root/.cache"]="/data/.cache"
MOUNTS["${ROOT}/input"]="/data/config/lora-scripts/input"
MOUNTS["${ROOT}/output"]="/output/lora-scripts"

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

if [ -f "/data/config/lora-scripts/startup.sh" ]; then
  pushd ${ROOT}
  . /data/config/lora-scripts/startup.sh
  popd
fi

git config --global --add safe.directory '*'

exec "$@"
