#!/bin/bash
# Build package "Uninstall-MacKeeper-VERSION.pkg".

export PATH='/usr/bin:/bin:/usr/sbin:/sbin'

NAME='Uninstall-MacKeeper'
IDENTIFIER="com.github.bjoernalbers.${NAME}"
VERSION="$(date '+%Y%m%dT%H%M%SZ')"
BASE_DIR="$(dirname "$0")"
BUILD_DIR="${BASE_DIR}/tmp"
SCRIPTS_DIR="${BASE_DIR}/uninstaller"
SUFFIX='pkg'

display_usage() {
cat <<EOM
Usage: $0 [OPTIONS]

Options:
  -h, --help             Display this help and exit
  -r, --release          Create release package
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
  pkgbuild \
    --scripts "${SCRIPTS_DIR}" \
    --nopayload \
    --identifier "${IDENTIFIER}" \
    --version "${VERSION:?}" \
    --quiet \
    "${PACKAGE}" && echo "${PACKAGE}"
fi
