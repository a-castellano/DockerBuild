#!/bin/bash -
#===============================================================================
#
#          FILE: build_docker_image__functions
# 
#         USAGE: source lib/build_docker_image
# 
#   DESCRIPTION: Build docker images following Daedalus Project Limani original behaviour.
# 
#       OPTIONS: ---
#  REQUIREMENTS: docker
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 04/24/2019 06:59
#      REVISION: 0.1
#===============================================================================

# Functions

function debug {

    if [ -n "$DEBUG" ]; then
        echo $?
    fi
}

function show_error {

    echo "$@" 1>&2
    exit 1
}

function check_variables {

    debug "Initiating check_variables."
    debug "Checking Docker Organization variables."
    if [[ -z ${DOCKER_ORGANIZATION_NAME} ]]; then
        show_error "Docker hub organization name not provided."
    fi

    debug "Checking maintainer variables."
    if [[ -z ${DOCKER_IMAGES_MAINTAINER} ]]; then
        show_error "Docker hub organization name not provided."
    fi

    debug "Checking Docker login variables."

    if [[ -z ${DOCKERHUBUSER} ]]; then
        show_error "Docker hub user not provided."
    fi

    if [[ -z ${DOCKERHUBPASSWORD} ]]; then
        show_error "Docker hub password not provided."
    fi

    debug "Checking IMAGE variables."
    if  [[ -z $IMAGENAME ]]; then

        show_error "IMAGENAME env variable is not set."
    fi
}

function setup {

    debug "Initiating setup."

    if  [[ $IS_BASE_IMAGE == 1 ]]; then

        debug "Current image is a base image type."
        mkdir -p timestamp
        DATESTRING=$(date +%Y%m%d%H%M)
        echo "$DATESTRING" > timestamp/timestampfile
    else
        debug "Current image is not a base image type."
        DATESTRING=$(cat timestamp/timestampfile)
        BASEIMAGE=$(grep "ARG BASE_IMAGE=" "${IMAGENAME}"/Dockerfile |sed 's/:.*//' | sed 's/ARG BASE_IMAGE=//')
        debug "Checking if base image value is rightfully set."
        if [ "$BASEIMAGE" -eq "" ]; then
            show_error "Cannot parse BASEIMAGE value."
        fi
    fi

    debug "Setting build options."

    if  [[ -z $BUILD_OPTIONS ]]; then
        BUILD_OPTIONS="--network=host --no-cache"
    fi

    debug "Setting tag options."

    if  [[ -z $LATEST_TAG_NAME ]]; then
        LATEST_TAG_NAME="latest"
    fi

    debug "Determining Repository current branch name."

    if  [[ -z $CI_COMMIT_REF_NAME ]]; then
        branch_name="$(git symbolic-ref HEAD 2>/dev/null)" || branch_name="(unnamed branch)"
        BRANCH=${branch_name##refs/heads/}
    else
        BRANCH=$CI_COMMIT_REF_NAME
    fi

}

function build_image {

    docker build "$BUILD_OPTIONS" -t "${IMAGENAME}" -f "${IMAGENAME}"/Dockerfile .
    docker login --username "${DOCKERHUBUSER}" --password "${DOCKERHUBPASSWORD}"
    docker create --name="${IMAGENAME}" -i "${IMAGENAME}"
}

function tag_image {

    debug docker tag "${IMAGENAME}" "${DOCKER_ORGANIZATION_NAME}"/"${IMAGENAME}":"$LATEST_TAG_NAME"
    docker tag "${IMAGENAME}" "${DOCKER_ORGANIZATION_NAME}"/"${IMAGENAME}":"$LATEST_TAG_NAME"

    if [ "${BRANCH}" == "master" ]; then
        debug docker tag "${IMAGENAME}" "${DOCKER_ORGANIZATION_NAME}"/"${IMAGENAME}":"${DATESTRING}"
        docker tag "${IMAGENAME}" "${DOCKER_ORGANIZATION_NAME}"/"${IMAGENAME}":"${DATESTRING}"
    fi
}

function commit_image {

    RELEASEDATE=$(date)
    debug docker commit -m "$RELEASEDATE" -a "${DOCKER_IMAGES_MAINTAINER}" "${IMAGENAME}" "${DOCKER_ORGANIZATION_NAME}"/"${IMAGENAME}"
    docker commit -m "$RELEASEDATE" -a "${DOCKER_IMAGES_MAINTAINER}" "${IMAGENAME}" "${DOCKER_ORGANIZATION_NAME}"/"${IMAGENAME}"
    if [ "${BRANCH}" == "master" ]; then
        debug docker push "${DOCKER_ORGANIZATION_NAME}"/"${IMAGENAME}":"${DATESTRING}"
        docker push "${DOCKER_ORGANIZATION_NAME}"/"${IMAGENAME}":"${DATESTRING}"
    fi
    docker push "${DOCKER_ORGANIZATION_NAME}"/"${IMAGENAME}":latest
}

function clean_images {
    debug docker stop "${IMAGENAME}"
    docker stop "${IMAGENAME}"
    debug docker rm "${IMAGENAME}"
    docker rm "${IMAGENAME}"
    debug docker rmi "${IMAGENAME}"
    docker rmi "${IMAGENAME}"
}
