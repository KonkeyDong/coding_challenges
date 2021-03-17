#!/bin/bash

CWD=$(dirname "$(readlink -f "$0")")
USERNAME=konkeydong
IMAGE=${USERNAME}/lua:latest
VOLUME=-v\ "$(pwd):/app/src"

build()
{
    docker build -t ${IMAGE} .
}

exec()
{
    docker run -it ${VOLUME} ${IMAGE}
}

run_tests()
{
    docker run -it ${VOLUME} ${IMAGE} /bin/bash -c "busted /app/src/coding_questions/data_structures"
}

push()
{
    docker push ${IMAGE}
}

pull()
{
    docker pull ${IMAGE}
}

help()
{
    cat << EOF
    build:     Build the docker image named "lua:latest"
    exec:      Exec into a container for direct interaction.
    run_tests: Run lua unit tests.
    help:      Display this help screen and exit.
    push:      Push image to Docker Hub.
    pull:      Pull image from Docker Hub.
EOF

    exit 0
}

eval $@
