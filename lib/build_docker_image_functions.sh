#!/bin/bash -
#===============================================================================
#
#          FILE: build_docker_image_functions.sh
#
#         USAGE: source lib/build_docker_image
#
#   DESCRIPTION: Build docker images.
#
#       OPTIONS: ---
#  REQUIREMENTS: docker
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 24/04/2019 06:59
#      REVISION: 0.2
#===============================================================================

# Functions

function debug {

	if [ -n "${DEBUG}" ]; then
		echo "$@"
	fi
}

function show_error {

	echo "$@" 1>&2
}

function check_variables {

	debug "Initiating check_variables."

	debug "Cheking first if registry URL has been set."

	if [[ -z ${DOCKER_REGISTRY_URL} ]]; then
		debug "DOCKER_REGISTRY_URL variable has not been set, asuming Dokcer Hub as registry."
		debug "Checking Docker Organization variables."
		if [[ -z ${DOCKER_ORGANIZATION_NAME} ]]; then
			show_error "Docker hub organization name (DOCKER_ORGANIZATION_NAME) not provided."
			return 1
		fi
	fi

	debug "Checking maintainer variable."
	if [[ -z ${DOCKER_IMAGES_MAINTAINER} ]]; then
		show_error "Image maintainer (DOCKER_IMAGES_MAINTAINER) not provided."
		return 1
	fi

	debug "Checking Docker login variables."

	if [[ -z ${DOCKER_REGISTRY_USER} ]]; then
		show_error "Registry user (DOCKER_REGISTRY_USER) not provided."
		return 1
	fi

	if [[ -z ${DOCKER_REGISTRY_PASSWORD} ]]; then
		show_error "Registry user password (DOCKER_REGISTRY_PASSWORD) not provided."
		return 1
	fi

	debug "Checking IMAGE_NAME variable."
	if [[ -z ${IMAGE_NAME} ]]; then

		show_error "IMAGE_NAME env variable is not set."
		return 1
	fi

	debug "Checking BUILD_PATH variable."
	if [[ -z ${BUILD_PATH} ]]; then

		BUILD_PATH="."
	fi
	return 0

}

function setup {

	debug "Initiating setup."

	if [[ ${IS_BASE_IMAGE} == 1 ]]; then

		debug "Current image is a base image type."
		mkdir -p ${BUILD_PATH}/timestamp
		DATESTRING=$(date +%Y%m%d%H%M)
		echo "${DATESTRING}" >${BUILD_PATH}/timestamp/timestampfile
	else
		debug "Current image is not a base image type."
		DATESTRING=$(cat ${BUILD_PATH}/timestamp/timestampfile)
		if [[ -z ${DATESTRING} ]]; then

			show_error "DATESTRING env variable is not set."
			return 1
		fi

		BASEIMAGE=$(grep "ARG BASE_IMAGE=" "${BUILD_PATH}/${IMAGE_NAME}"/Dockerfile | sed 's/:.*//' | sed 's/ARG BASE_IMAGE=//')
		debug "Checking if base image value is rightfully set."
		if [[ "${BASEIMAGE}" == "" ]]; then
			show_error "Cannot parse BASEIMAGE value."
			return 1
		fi
	fi

	debug "Setting build options."

	if [[ -z ${BUILD_OPTIONS} ]]; then
		BUILD_OPTIONS="--network=host --no-cache"
	fi

	debug "Setting tag options."

	if [[ -z ${LATEST_TAG_NAME} ]]; then
		LATEST_TAG_NAME="latest"
	fi

	debug "Determining Repository current branch name."

	if [[ -z ${CI_COMMIT_REF_NAME} ]]; then
		branch_name="$(git symbolic-ref HEAD 2>/dev/null)" || branch_name="(unnamed branch)"
		BRANCH=${branch_name##refs/heads/}
	else
		BRANCH=${CI_COMMIT_REF_NAME}
	fi

}

function build_image {

	debug "docker login"
	docker login --username "${DOCKER_REGISTRY_USER}" --password "${DOCKER_REGISTRY_PASSWORD}" ${DOCKER_REGISTRY_URL}
	docker build ${BUILD_OPTIONS} -t "${IMAGE_NAME}" -f "${IMAGE_NAME}/Dockerfile" .
	debug docker create --name="${IMAGE_NAME}" -i "${IMAGE_NAME}"
	docker create --name="${IMAGE_NAME}" -i "${IMAGE_NAME}"
}

function tag_image {

	debug docker tag "${IMAGE_NAME}" "${DOCKER_ORGANIZATION_NAME}"/"${IMAGE_NAME}":"${LATEST_TAG_NAME}"
	docker tag "${IMAGE_NAME}" "${DOCKER_ORGANIZATION_NAME}"/"${IMAGE_NAME}":"${LATEST_TAG_NAME}"

	if [ "${BRANCH}" == "master" ]; then
		debug docker tag "${IMAGE_NAME}" "${DOCKER_ORGANIZATION_NAME}"/"${IMAGE_NAME}":"${DATESTRING}"
		docker tag "${IMAGE_NAME}" "${DOCKER_ORGANIZATION_NAME}"/"${IMAGE_NAME}":"${DATESTRING}"
	fi
}

function commit_image {

	RELEASE_DATE=$(date)
	debug docker commit -m "${RELEASE_DATE}" -a "${DOCKER_IMAGES_MAINTAINER}" "${IMAGE_NAME}" "${DOCKER_ORGANIZATION_NAME}"/"${IMAGE_NAME}"
	docker commit -m "${RELEASE_DATE}" -a "${DOCKER_IMAGES_MAINTAINER}" "${IMAGE_NAME}" "${DOCKER_ORGANIZATION_NAME}"/"${IMAGE_NAME}"
	if [[ "${BRANCH}" == "master" ]]; then
		debug docker push "${DOCKER_ORGANIZATION_NAME}"/"${IMAGE_NAME}":"${DATESTRING}"
		docker push "${DOCKER_ORGANIZATION_NAME}"/"${IMAGE_NAME}":"${DATESTRING}"
	fi
	docker push "${DOCKER_ORGANIZATION_NAME}"/"${IMAGE_NAME}":latest
}

function clean_images {
	debug docker stop "${IMAGE_NAME}"
	docker stop "${IMAGE_NAME}"
	debug docker rm "${IMAGE_NAME}"
	docker rm "${IMAGE_NAME}"
	debug docker rmi "${IMAGE_NAME}"
	docker rmi "${IMAGE_NAME}"
}
