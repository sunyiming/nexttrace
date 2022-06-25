#!/usr/bin/env bash

set -e

DIST_PREFIX="nexttrace"
DEBUG_MODE=${2}
TARGET_DIR="dist"
PLATFORMS="darwin/amd64 darwin/arm64 linux/386 linux/amd64 linux/arm64 linux/mips openbsd/amd64 openbsd/arm64 freebsd/amd64 freebsd/arm64 windows/386 windows/amd64"

BUILD_VERSION="$(git describe --tags --always)"
BUILD_DATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
COMMIT_SHA1="$(git rev-parse --short HEAD)"

rm -rf ${TARGET_DIR}
mkdir ${TARGET_DIR}

for pl in ${PLATFORMS}; do
    export GOOS=$(echo ${pl} | cut -d'/' -f1)
    export GOARCH=$(echo ${pl} | cut -d'/' -f2)
    export TARGET=${TARGET_DIR}/${DIST_PREFIX}_${GOOS}_${GOARCH}
    if [ "${GOOS}" == "windows" ]; then
        export TARGET=${TARGET_DIR}/${DIST_PREFIX}_${GOOS}_${GOARCH}.exe
    fi

    echo "build => ${TARGET}"
    if [ "${DEBUG_MODE}" == "debug" ]; then
        go build -trimpath -gcflags "all=-N -l" -o ${TARGET} \
            -ldflags    "-X 'github.com/xgadget-lab/nexttrace/printer.version=${BUILD_VERSION}' \
                        -X 'github.com/xgadget-lab/nexttrace/printer.buildDate=${BUILD_DATE}' \
                        -X 'github.com/xgadget-lab/nexttrace/printer.commitID=${COMMIT_SHA1}'\
                        -w -s"
    else
        go build -trimpath -o ${TARGET} \
            -ldflags    "-X 'github.com/xgadget-lab/nexttrace/printer.version=${BUILD_VERSION}' \
                        -X 'github.com/xgadget-lab/nexttrace/printer.buildDate=${BUILD_DATE}' \
                        -X 'github.com/xgadget-lab/nexttrace/printer.commitID=${COMMIT_SHA1}'\
                        -w -s"
    fi
done

    export GOOS='linux'
    export GOARCH='arm'
    export GOARM='7'
    export TARGET=${TARGET_DIR}/${DIST_PREFIX}_${GOOS}_${GOARCH}v7
    echo "build => ${TARGET}"
    if [ "${DEBUG_MODE}" == "debug" ]; then
        go build -trimpath -gcflags "all=-N -l" -o ${TARGET} \
            -ldflags    "-X 'github.com/xgadget-lab/nexttrace/printer.version=${BUILD_VERSION}' \
                        -X 'github.com/xgadget-lab/nexttrace/printer.buildDate=${BUILD_DATE}' \
                        -X 'github.com/xgadget-lab/nexttrace/printer.commitID=${COMMIT_SHA1}'\
                        -w -s"
    else
        go build -trimpath -o ${TARGET} \
            -ldflags    "-X 'github.com/xgadget-lab/nexttrace/printer.version=${BUILD_VERSION}' \
                        -X 'github.com/xgadget-lab/nexttrace/printer.buildDate=${BUILD_DATE}' \
                        -X 'github.com/xgadget-lab/nexttrace/printer.commitID=${COMMIT_SHA1}'\
                        -w -s"
    fi


