#!/bin/bash
# Build package "Uninstall-MacKeeper-VERSION.pkg".

export PATH='/usr/bin:/bin:/usr/sbin:/sbin'

NAME='Uninstall-MacKeeper'
IDENTIFIER="com.github.bjoernalbers.${NAME}"
VERSION="$(git describe --tags)"
BASE_DIR="$(dirname "$0")"
BUILD_DIR="${BASE_DIR}/pkgs"
SCRIPTS_DIR="${BASE_DIR}/scripts"
PACKAGE="${BUILD_DIR}/${NAME}-${VERSION}.pkg"

mkdir -p "${BUILD_DIR}"
if [[ ! -e "${PACKAGE}" ]]; then
  pkgbuild \
    --scripts "${SCRIPTS_DIR}" \
    --nopayload \
    --identifier "${IDENTIFIER}" \
    --version "${VERSION:?}" \
    --quiet \
    "${PACKAGE}" && echo "${PACKAGE}"
fi
