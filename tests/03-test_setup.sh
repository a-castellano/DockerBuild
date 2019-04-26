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

setUp(){
    DOCKER_ORGANIZATION_NAME="daedalusproject"
    DOCKER_IMAGES_MAINTAINER="Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>"
    DOCKERHUBUSER="alvaro.castellano.vela"
    DOCKERHUBPASSWORD="mypassword"
    BUILD_PATH="$TMP_FOLDER"
    check_variables
}

tearDown() {
    unset DOCKER_ORGANIZATION_NAME
    unset DOCKER_IMAGES_MAINTAINER
    unset DOCKERHUBUSER
    unset DOCKERHUBPASSWORD
    unset IMAGENAME
    unset BUILD_PATH
    unset BUILD_OPTIONS
    unset LATEST_TAG_NAME
    unset branch_name
    unset BRANCH
}

testIsBaseImage() {
    IS_BASE_IMAGE=1
    setup
    test -d $BUILD_PATH/timestamp
    check_timestamp_folder=$?
    assertEquals "0" "$check_timestamp_folder"
    test -f $BUILD_PATH/timestamp/timestampfile
    check_timestamp_file=$?
    assertEquals "0" "$check_timestamp_file"
}

# Load shUnit2.
. /usr/bin/shunit2
