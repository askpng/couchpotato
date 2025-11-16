# List recipes
@default:
    just --list

set shell := ["bash", "-c"]
RCPDIR := "./recipes"
VERSION := "local"
USRN := "bootc"
PSWD := "bootc"

# Build image-name as named in ./recipes/images
build *ARGS:
    bluebuild build --skip-validation -s -c zstd "{{ RCPDIR }}"/"{{ ARGS }}".yml

# Build, create, and purge archive of image-name as named in ./recipes/images. Useful for testing recipes
targz *ARGS:
    bluebuild build --skip-validation -s -c zstd -a ./ "{{ RCPDIR }}"/"{{ ARGS }}".yml
    rm -f ./tmp.tar.gz
    rm -rf ./.bluebuild-scripts_*    

# Build image-name as named in ./recipes/images and export a VM-ready QCOW2 file in ./qcow2
qcow2 *ARGS: config
    bluebuild generate -o Containerfile."{{ ARGS }}" "{{ RCPDIR }}"/"{{ ARGS }}".yml
    sudo podman build -t "{{ ARGS }}":"{{ VERSION }}" --file Containerfile."{{ ARGS }}" --squash
    sudo podman run --rm -it --privileged \
        --security-opt label=type:unconfined_t \
        -v /var/lib/containers/storage:/var/lib/containers/storage \
        -v .:/output \
        -v ./config.toml:/config.toml:ro \
        quay.io/centos-bootc/bootc-image-builder:latest \
        --rootfs btrfs \
        --use-librepo=True \
        --chown 1000:1000 \
        "{{ ARGS }}":"{{ VERSION }}"
    sudo rm ./manifest*
    sudo rm -rf ./.bluebuild*
    rm Containerfile."{{ ARGS }}"

# Completely clean user & system-level Podman image registry & ./
scrub:
    podman rmi -f $(podman images -f "dangling=true" -q)
    sudo podman rmi -f $(sudo podman images -f "dangling=true" -q)
    rm -rf ./qcow2 ./.bluebuild-scripts_* 
    rm -f ./tmp.tar.gz ./config.toml

# Generate config.toml file for bootc-image-builder
config:
    #!/usr/bin/env bash
    if [[ ! -e ./config.toml ]]; then
        echo "Generating config.toml..."
        cat <<EOF >> ./config.toml
    [[customizations.user]]
    name = "{{ USRN }}"
    password = "{{ PSWD }}"
    groups = ["wheel"]
    EOF
    echo "config.toml generated."
    else
        echo "config.toml already exists."
    fi