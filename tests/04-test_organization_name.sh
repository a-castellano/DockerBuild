#!/bin/bash -
#===============================================================================
#
#          FILE: 03-test_setup.sh
#
#   DESCRIPTION: Test setup

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 04/26/2019 05:58
#===============================================================================

source lib/build_docker_image_functions.sh

oneTimeSetUp() {
	export TMP_FOLDER="/var/tmp/dockerbuild/tests"
	mkdir -p $TMP_FOLDER
}

oneTearDown() {
	rm -rv $TMP_FOLDER
}

setUp() {
	DOCKER_REGISTRY_URL="registry.windmaker.net:5005/a-castellano/Docker-Build"
	DOCKER_IMAGES_MAINTAINER="Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>"
	DOCKER_REGISTRY_USER="alvaro.castellano.vela"
	DOCKER_REGISTRY_PASSWORD="mypassword"
	BUILD_PATH="$TMP_FOLDER"
	IMAGE_NAME="testimage"
	check_variables
}

tearDown() {
	unset DOCKER_ORGANIZATION_NAME
	unset DOCKER_IMAGES_MAINTAINER
	unset DOCKER_REGISTRY_USER
	unset DOCKER_REGISTRY_PASSWORD
	unset IMAGE_NAME
	unset BUILD_PATH
	unset BUILD_OPTIONS
	unset LATEST_TAG_NAME
	unset branch_name
	unset BRANCH
	unset DOCKER_REGISTRY_URL
}

testImageChangesNameWhenUsingDokcerRegistry() {
	DOCKER_ORGANIZATION_NAME="testorganization"
	rename_organization
	assertEquals "registry.windmaker.net:5005/a-castellano/Docker-Build" "$DOCKER_ORGANIZATION_NAME"
}

testImageChangesNameWhenNotUsingDokcerRegistry() {
	unset DOCKER_REGISTRY_URL
	DOCKER_ORGANIZATION_NAME="test2"
	rename_organization
	assertEquals "test2" "$DOCKER_ORGANIZATION_NAME"
}

# Load shUnit2.
. /usr/bin/shunit2
