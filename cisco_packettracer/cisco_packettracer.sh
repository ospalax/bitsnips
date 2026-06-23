#!/bin/sh

#
# edit this if you need
#

DOCKER="${DOCKER:-podman}"
IMAGE="${IMAGE:-cisco_packettracer}"
ARCHIVE="${ARCHIVE:-download/${IMAGE}.tgz}"
CISCO_FILE="${CISCO_FILE:-download/CiscoPacketTracer_900_Ubuntu_64bit.deb}"
UBUNTU_VERSION="${UBUNTU_VERSION:-22.04}"
BROWSER_APP="${BROWSER_APP:-elinks}" # more options in the README

#
# do not touch below
#

CMD=$(basename "${0}")

help() {
    cat <<EOF
NAME
    ${CMD} - tool to run cisco packettracer:

        1. more safely inside the container
        2. allows to run it on non-ubuntu distro

SYNOPSIS
    ${CMD} [help]
        This help

    ${CMD} build
        build the image - can be modified with the following variables:

        CISCO_FILE:
            path to the cisco package (must be inside the same directory as the
            Dockerfile...)

            default=${CISCO_FILE}

        UBUNTU_VERSION:
            change as needed - read the cisco documentation

            default=${UBUNTU_VERSION}

        BROWSER_APP:
            cisco will require to login via browser - this selects which
            browser to install (terminal browsers work too...)

            default=${BROWSER_APP}

    ${CMD} save [ARCHIVE]
        save the image to a archive - useful if you have ephemeral setup for
        container storage...

        ARCHIVE:
            path to the archive - works as argument and env. variable

            default=${ARCHIVE}

    ${CMD} load [ARCHIVE]
        load the saved image

        ARCHIVE:
            path to the archive - works as argument and env. variable

            default=${ARCHIVE}

    ${CMD} run
        simply start the container with the app (it must be built or loaded...)
EOF
}

#
# main
#

case "$1" in
    ''|help)
        help
        exit 0
        ;;
    build)
        ACTION=build
        ;;
    save)
        ACTION=save
        if [ -z "$ARCHIVE" ]; then
            ARCHIVE="$2"
        fi
        ;;
    load)
        ACTION=load
        if [ -z "$ARCHIVE" ]; then
            ARCHIVE="$2"
        fi
        ;;
    run)
        ACTION=run
        ;;
    *)
        help
        exit 1
        ;;
esac

case "$ACTION" in
    build)
        ${DOCKER} build \
            -t "${IMAGE}" \
            --build-arg CISCO_FILE="${CISCO_FILE}" \
            --build-arg UBUNTU_VERSION="${UBUNTU_VERSION}" \
            --build-arg BROWSER_APP="${BROWSER_APP}" \
            -f Dockerfile-cisco
        ;;
    save)
        ${DOCKER} image save \
            "${IMAGE}" \
            | gzip > "${ARCHIVE}"
        ;;
    load)
        gzip -cd "${ARCHIVE}" | ${DOCKER} image import - "${IMAGE}"
        ;;
    run)
        ${DOCKER} run -it \
            --userns keep-id \
            --env=XAUTHORITY="${XAUTHORITY}" \
            --env=DISPLAY="${DISPLAY}" \
            -v "/tmp/.X11-unix:/tmp/.X11-unix:ro" \
            -v "${XAUTHORITY}:${XAUTHORITY}:ro" \
            --security-opt label=type:container_runtime_t \
            --env=LANG="C.UTF-8" \
            "${IMAGE}"
        ;;
esac

exit $?
