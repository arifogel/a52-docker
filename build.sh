#!/usr/bin/env bash

set -euo pipefail

export LIBASOUND2_PLUGINS_VERSION="$(apt-cache policy libasound2-plugins | grep Candidate | awk '{print $2}')"
export A52_DEB_VERSION="${LIBASOUND2_PLUGINS_VERSION}-dev1"
export DEB_FILE="libasound2-plugins-a52_${A52_DEB_VERSION}_amd64.deb"
export UBUNTU_VERSION="$(lsb_release -sr)"
envsubst '
  ${LIBASOUND2_PLUGINS_VERSION}
  ${A52_DEB_VERSION}
  ${UBUNTU_VERSION}
  ${DEB_FILE}
' \
  < Dockerfile.in \
  > Dockerfile
docker build \
  -t a52-build \
  .

docker run a52-build cat "/root/workdir/${DEB_FILE}" > "${DEB_FILE}"

cat <<EOF
Build succeded for: ${DEB_FILE}"
To install, run: sudo dpkg -i "${DEB_FILE}"
EOF

