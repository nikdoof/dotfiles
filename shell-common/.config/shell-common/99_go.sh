# shellcheck shell=bash
# Go stuff

export GOPATH=$XDG_DATA_HOME/go/
export PATH=${GOPATH}bin:$PATH
if [ -z ${GOROOT+x} ] && [ -d /usr/local/go ]; then
    export GOROOT=/usr/local/go/
    export PATH=$PATH:$GOROOT/bin
fi
