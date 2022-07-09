#!/bin/bash
set -e

# The install.sh script is the installation entrypoint for any dev container 'features' in this repository. 
#
# The tooling will parse the devcontainer-features.json + user devcontainer, and write 
# any build-time arguments into a feature-set scoped "devcontainer-features.env"
# The author is free to source that file and use it however they would like.
set -a
. ./devcontainer-features.env
set +a

latest="392.0.0"

if [ `uname -m` = 'x86_64' ]; then echo -n "x86_64" > /tmp/arch; else echo -n "arm" > /tmp/arch; fi;
ARCH=`cat /tmp/arch`

if [ ! -z ${_BUILD_ARG_GOOGLE_CLOUD_SDK} ]; then
    echo "Activating feature 'gcloud'"

    # Build args are exposed to this entire feature set following the pattern:  _BUILD_ARG_<FEATURE ID>_<OPTION NAME>
    CLOUD_SDK_VERSION=${_BUILD_ARG_GOOGLE_CLOUD_SDK_VERSION:-${latest}}
    if [ "$CLOUD_SDK_VERSION" = 'latest' ]; then CLOUD_SDK_VERSION=$latest; fi;
    DOWNLOAD_URL=https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-${ARCH}.tar.gz

    echo "Donwload: $DOWNLOAD_URL"
    curl -O $DOWNLOAD_URL
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-${ARCH}.tar.gz
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-${ARCH}.tar.gz

    mkdir -p /usr/share
    mv ./google-cloud-sdk /usr/share/google-cloud-sdk

    INSTALL_COMPONENTS=(${_BUILD_ARG_GOOGLE_CLOUD_SDK_INSTALL_COMPONENTS//,/ })
    for component in "${INSTALL_COMPONENTS[@]}"; do
        sudo /usr/share/google-cloud-sdk/bin/gcloud components install $component
    done

    # Setup execution commands
    for file in /usr/share/google-cloud-sdk/bin/*; do
        sudo ln -s $file /usr/local/bin/$(basename $file)
    done
fi
