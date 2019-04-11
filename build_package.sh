#!/bin/bash
# Build package "Uninstall-MacKeeper-VERSION.pkg".

export PATH='/usr/bin:/bin:/usr/sbin:/sbin'

NAME='Uninstall-MacKeeper'
IDENTIFIER="com.github.bjoernalbers.${NAME}"
IDENTITY_NAME='Developer ID Installer: Bjoern Albers (2M83WXV6U8)'
VERSION="$(date '+%Y%m%dT%H%M%SZ')"
BASE_DIR="$(dirname "$0")"
BUILD_DIR="${BASE_DIR}/tmp"
SCRIPTS_DIR="${BASE_DIR}/uninstaller"
SUFFIX='pkg'
PKGBUILD_OPTIONS=(
  --scripts "${SCRIPTS_DIR}"
  --nopayload
  --identifier "${IDENTIFIER}"
  --version "${VERSION:?}"
  --quiet
)

display_usage() {
cat <<EOM
Usage: $0 [OPTIONS]

Options:
  -h, --help             Display this help and exit
  -r, --release          Create signed release package
EOM
}

# Process options
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -h|--help)
      display_usage
      exit 0
      ;;
    -r|--release)
      VERSION="$(git describe --tags)"
      BUILD_DIR="${BASE_DIR}/pkgs"
      PKGBUILD_OPTIONS+=(--sign "${IDENTITY_NAME}")
      ;;
    *)
      display_usage >&2
      exit 1
      ;;
  esac
  shift
done

# Build package
mkdir -p "${BUILD_DIR}"
PACKAGE="${BUILD_DIR}/${NAME}-${VERSION}.${SUFFIX}"
if [[ ! -e "${PACKAGE}" ]]; then
  pkgbuild "${PKGBUILD_OPTIONS[@]}" "${PACKAGE}" && echo "${PACKAGE}"
fi
