# +---------------------------------------------------------------------------
# : Project specific recipes
# +---------------------------------------------------------------------------
# Build or rebuild services
build *OPTIONS:
    @docker compose --file docker-compose-${COMMON_ENVIRONMENT}.yaml build {{OPTIONS}}

# Create and start containers (detached)
up *OPTIONS:
    @docker compose --file docker-compose-${COMMON_ENVIRONMENT}.yaml up -d {{OPTIONS}}

# Stop and remove containers, networks
down:
    @docker compose --file docker-compose-${COMMON_ENVIRONMENT}.yaml down

# Stop and remove containers, networks, remove orphans and volumes
down-pp:
    @docker compose --file docker-compose-${COMMON_ENVIRONMENT}.yaml down --remove-orphans --volumes

# List containers
ps *OPTIONS:
    @docker compose --file docker-compose-${COMMON_ENVIRONMENT}.yaml ps {{OPTIONS}}

# Restart service containers
restart:
    @docker compose --file docker-compose-${COMMON_ENVIRONMENT}.yaml restart

# Watch build context for service and rebuild/refresh containers when files are updated
watch:
    @docker compose --file docker-compose-${COMMON_ENVIRONMENT}.yaml watch

# Execute a COMMAND in CONTAINER container
exec CONTAINER *COMMAND:
    @docker compose --file docker-compose-${COMMON_ENVIRONMENT}.yaml exec {{CONTAINER}} {{COMMAND}}

# Launch SHELL in CONTAINER
shell CONTAINER SHELL="bash": 
    @docker compose --file docker-compose-${COMMON_ENVIRONMENT}.yaml exec {{CONTAINER}} {{SHELL}}

# Display tdout logs in CONTAINER 
logs CONTAINER:
    @docker compose --file docker-compose-${COMMON_ENVIRONMENT}.yaml logs -f -n 40 {{CONTAINER}}

# Execute a gradle COMMAND in a new CONTAINER
gradle CONTAINER *COMMAND:
    @docker compose --file docker-compose-${COMMON_ENVIRONMENT}.yaml exec {{CONTAINER}} gradle {{COMMAND}}

# Execute a gradlew COMMAND in a new CONTAINER
gradlew CONTAINER *COMMAND:
    @docker compose --file docker-compose-${COMMON_ENVIRONMENT}.yaml exec {{CONTAINER}} ./gradlew {{COMMAND}}

# Clean Bash History file
history-clean CONTAINER:
    @echo -n > ./data/tmp/.bash_history

[private]
@help:
    echo "🛟  Project Help 🛟"
    just --list --list-heading '' --list-prefix "    ↪ " --justfile {{justfile()}}

# Setting up the project
[private]
@setup:
    #!/usr/bin/env sh
    echo "🚧  Project Setup 🚧"
    cd ..
    if [ ! -e .env ]; then
        echo ">>> Create .env file"
        cp .env.dist .env
    fi

    mkdir -p data/opt
    mkdir -p data/tmp
    mkdir -p project
    touch data/tmp/.bash_history
