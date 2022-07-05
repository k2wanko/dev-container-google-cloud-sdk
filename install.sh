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

if [ ! -z ${_BUILD_ARG_GOOGLE_CLOUD_SDK} ]; then
    echo "Activating feature 'helloworld'"

    # Build args are exposed to this entire feature set following the pattern:  _BUILD_ARG_<FEATURE ID>_<OPTION NAME>
    GOOGLE_CLOUD_SDK_VERSION=${_BUILD_ARG_GOOGLE_CLOUD_SDK_VERSION:-undefined}

    env

    # chmod +x /usr/hello.sh
    # sudo cat '/usr/hello.sh' > /usr/local/bin/hello
    # sudo chmod +x /usr/local/bin/hello
fi
