#!/bin/sh

# Don't forget to run 'chmod +x ci_post_xcodebuild.sh' from the terminal after adding this file to your project

set -e
if [[ -n $CI_ARCHIVE_PATH ]];
then

    # Install Sentry CLI into the current directory ($CI_PRIMARY_REPOSITORY_PATH/ci_scripts)
    export INSTALL_DIR=$PWD

    if [[ $(command -v sentry-cli) == "" ]]; then
        curl -sL https://sentry.io/get-cli/ | bash
    fi

    # Upload dSYMs
    $CI_PRIMARY_REPOSITORY_PATH/ci_scripts/sentry-cli --auth-token $SENTRY_AUTH_TOKEN upload-dif --org $SENTRY_ORG --project $SENTRY_PROJECT $CI_ARCHIVE_PATH
else
    echo "Archive path isn't available. Unable to run dSYMs uploading script."
fi
