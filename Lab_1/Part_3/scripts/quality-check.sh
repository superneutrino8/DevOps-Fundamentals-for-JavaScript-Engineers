#!/bin/bash

# file configuration
SCRIPT_DIR=$(dirname "$(readlink -f "$BASH_SOURCE")")
ROOT_DIR=${SCRIPT_DIR%/*}
APP_DIR=$ROOT_DIR/shop-angular-cloudfront
CLIENT_BUILD_DIR=$APP_DIR/dist/static
CLIENT_BUILD_FILE=$APP_DIR/dist/client-app.zip

exitInCaseLastCommandFails() {
    if [ $? -eq 1 ]; then
        echo "Command '$1' failed"
        exit 1
    fi
}

# move to app directory
cd "${APP_DIR}"

# run lint
npm run lint --prefix "$APP_DIR"
exitInCaseLastCommandFails "npm run lint"

# run test
npm run test --prefix "$APP_DIR" -- --watch=false
exitInCaseLastCommandFails "npm run test"

# run audit
npm audit --prefix "$APP_DIR"
exitInCaseLastCommandFails "npm run audit"
