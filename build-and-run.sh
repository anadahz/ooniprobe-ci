#!/bin/sh
set -x
TARGET=$1
OS_NAME=$2
DOCKERFILE=Dockerfile.$TARGET

if [ -z $OS_NAME ];then
    echo "ERR: you must specify the OS name"
    exit 1
fi

case "$OS_NAME" in
    "osx")
        brew update >/dev/null
        brew install ooniprobe
        ./test/run.sh
        ;;

    "linux")
        if [ -z $TARGET ];then
            echo "ERR: you must specify the target"
            exit 1
        fi

        if [ ! -f $DOCKERFILE ];then
            echo "ERR: $DOCKERFILE does not exist"
            exit 2
        fi

        echo "Building $TARGET ($DOCKERFILE)"

        docker build -t ooniprobe/$TARGET -f $DOCKERFILE .
        docker run ooniprobe/$TARGET /ooniprobe/run.sh
        ;;
    *)
        echo "Invalid or unsupported operating system ${OS_NAME}"
        exit 1
        ;;
   esac
