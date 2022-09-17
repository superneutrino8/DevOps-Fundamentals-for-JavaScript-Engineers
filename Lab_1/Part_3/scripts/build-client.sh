#!/bin/bash

# file configuration
SCRIPT_DIR=$(dirname "$(readlink -f "$BASH_SOURCE")")
ROOT_DIR=${SCRIPT_DIR%/*}
APP_DIR=$ROOT_DIR/shop-angular-cloudfront
CLIENT_BUILD_DIR=$APP_DIR/dist/static
CLIENT_BUILD_FILE=$APP_DIR/dist/client-app.zip

# REQ 1: Install the app’s npm dependencies.
cd "${APP_DIR}" && npm i

# REQ 2 & 3: RUn bild script and setup ENV
cd "$APP_DIR" && ng build --configuration=$ENV_CONFIGURATION --output-path="$CLIENT_BUILD_DIR"

# REQ 4: Remove ZIP file if exists and compress build
if [ -f "$CLIENT_BUILD_FILE" ] ; then
    rm "$CLIENT_BUILD_FILE"
fi
7z a -tzip "$CLIENT_BUILD_FILE" "$CLIENT_BUILD_DIR/*"
