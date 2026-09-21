#!/bin/bash

CURRENT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PDFGENRS_VERSION=$(grep -m1 'ghcr.io/navikt/pdfgenrs' "$CURRENT_PATH/Dockerfile" | grep -o '[0-9][^"]*$')
PDFGENRS_IMAGE="ghcr.io/navikt/pdfgenrs:${PDFGENRS_VERSION}"

docker pull "$PDFGENRS_IMAGE"
docker run \
        -v $CURRENT_PATH/templates:/app/templates \
        -v $CURRENT_PATH/fonts:/app/fonts \
        -v $CURRENT_PATH/data:/app/data \
        -v $CURRENT_PATH/resources:/app/resources \
        -v $CURRENT_PATH/lib:/app/lib \
        -p 8089:8080 \
        -e DEV_MODE=true \
        -e REQUEST_BODY_LIMIT_BYTES=52428800 \
        -e MAX_IMAGE_DIMENSION_PIXELS=16384 \
        -e MAX_IMAGE_PIXELS=64000000 \
        -e MAX_CONCURRENT_COMPILATIONS=2 \
        -e COMPILE_TIMEOUT_SECONDS=60 \
        -it \
        --rm \
        "$PDFGENRS_IMAGE"