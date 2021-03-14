$CWD = Get-Location | Foreach-Object { $_.path }
$IMAGE = "lua:latest"
$VOLUME = "-v ${CWD}:/app/src"

function build
{
    docker build -t $IMAGE
}

function exec
{
    docker run -it $VOLUME $IMAGE /bin/bash
}

function run_tests()
{
    docker run -it $VOLUME $IMAGE /bin/bash -c "cd /app/src/coding_questions/data_structures; busted"
}

function help
{
@"
    build:     Build the docker image named "lua:latest"
    exec:      Exec into a container for direct interaction.
    run_tests: Run lua unit tests.
    help:      Display this help screen and exit.
"@
}
