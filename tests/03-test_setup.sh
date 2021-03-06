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
	DOCKER_ORGANIZATION_NAME="daedalusproject"
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
}

testIsBaseImage() {
	unset CI_COMMIT_REF_NAME
	IS_BASE_IMAGE=1
	setup
	test -d $BUILD_PATH/timestamp
	check_timestamp_folder=$?
	assertEquals "0" "$check_timestamp_folder"
	test -f $BUILD_PATH/timestamp/timestampfile
	check_timestamp_file=$?
	assertEquals "0" "$check_timestamp_folder"
	assertEquals "0" "$check_timestamp_file"
	assertEquals "--network=host --no-cache" "$BUILD_OPTIONS"
	assertEquals "latest" "$LATEST_TAG_NAME"
}

testIsuNOTBaseImageNotDateString() {

	unset CI_COMMIT_REF_NAME
	IS_BASE_IMAGE=0
	BUILD_PATH=$(pwd)/tests
	IMAGE_NAME="base_image_test"
	setup 2>/dev/null
	setupError=$?
	assertEquals "1" "$setupError"
	#There is not timestampfile so IMAGE_NAME is not set
}

testIsuNOTBaseImage() {
	unset CI_COMMIT_REF_NAME
	IS_BASE_IMAGE=0
	cp -R tests/base_image_test $BUILD_PATH/
	mkdir -p $BUILD_PATH/timestamp
	DATESTRING=$(date +%Y%m%d%H%M)
	echo "$DATESTRING" >$BUILD_PATH/timestamp/timestampfile
	IMAGE_NAME="base_image_test"
	setup
	setupError=$?
	assertEquals "0" "$setupError"
}

testIsuNOTBaseImageFailedToGetBaseImage() {
	unset CI_COMMIT_REF_NAME
	IS_BASE_IMAGE=0
	cp -R tests/base_image_test $BUILD_PATH/
	mkdir -p $BUILD_PATH/timestamp
	DATESTRING=$(date +%Y%m%d%H%M)
	echo "$DATESTRING" >$BUILD_PATH/timestamp/timestampfile
	IMAGE_NAME="nonexistent"
	setup 2>/dev/null
	setupError=$?
	assertEquals "1" "$setupError"
	#There is not dockerfile so IMAGE_NAME is not set
}

testCI_COMMIT_REF_NAME() {
	CI_COMMIT_REF_NAME="master"
	IS_BASE_IMAGE=0
	cp -R tests/base_image_test $BUILD_PATH/
	mkdir -p $BUILD_PATH/timestamp
	DATESTRING=$(date +%Y%m%d%H%M)
	echo "$DATESTRING" >$BUILD_PATH/timestamp/timestampfile
	IMAGE_NAME="base_image_test"
	setup
	setupError=$?
	assertEquals "0" "$setupError"
}

# Load shUnit2.
. /usr/bin/shunit2
