#!/usr/bin/env sh
cd "$(dirname "$0")" || exit 1

PROJ="__pini__"
OS="linux"
PLAT="x86_64"
MODE="release"  # or debug


if [ "$1" = "dev" ]; then
    MODE="debug"
    shift
fi
copy_bin="./build/${OS}/${PLAT}/${MODE}/${PROJ}"


xmake config \
    --mode="$MODE" \
    -y

nproc="$(getconf _NPROCESSORS_ONLN)"
xmake build -j"$(nproc)" "${PROJ}" || exit $?

command cp "$(dirname "$copy_bin")"/"${PROJ}" "${PROJ}"

