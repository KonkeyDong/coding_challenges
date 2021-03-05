#!/bin/bash

CWD=$(dirname "$(readlink -f "$0")")
IMAGE=lua:latest
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
    docker run -it ${VOLUME} ${IMAGE} /bin/bash -c "cd /app/src/coding_questions/data_structures; busted"
}

help()
{
    cat << EOF
    build:     Build the docker image named "lua:latest"
    exec:      Exec into a container for direct interaction.
    run_tests: Run lua unit tests.
    help:      Display this help screen and exit.
EOF

    exit 0
}

eval $@
