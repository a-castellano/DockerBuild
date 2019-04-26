#!/bin/bash -
#===============================================================================
#
#          FILE: 01-variables.sh
#
#   DESCRIPTION: Test varaible parsing

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 04/26/2019 05:58
#===============================================================================

source lib/build_docker_image_functions.sh

oneTimeSetUp() {
    export TMP_FOLDER="/var/tmp/dockerbuild/tests"
    mkdir -p $TMP_FOLDER
}

TearDown() {
    unset DOCKER_ORGANIZATION_NAME
    unset DOCKER_IMAGES_MAINTAINER
    unset DOCKERHUBUSER
    unset DOCKERHUBPASSWORD
    unset IMAGENAME
}

testNoVariables() {
    check_variables 2> $TMP_FOLDER/testNoVariables
    check_variables_status=$?
    check_variables_message=$(cat $TMP_FOLDER/testNoVariables)
    assertEquals "1" "$check_variables_status"
    assertEquals "Some message" "$check_variables_message"
}

# Load shUnit2.
. /usr/bin/shunit2
