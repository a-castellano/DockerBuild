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

tearDown() {
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
    assertEquals "Docker hub organization name not provided." "$check_variables_message"
}

testOnlyImagename() {
    IMAGENAME="SomeImage"
    check_variables 2> $TMP_FOLDER/testNoVariables
    check_variables_status=$?
    check_variables_message=$(cat $TMP_FOLDER/testNoVariables)
    assertEquals "1" "$check_variables_status"
    assertEquals "Docker hub organization name not provided." "$check_variables_message"
}

testWithDOCKER_ORGANIZATION_NAME() {
    DOCKER_ORGANIZATION_NAME="daedalusproject"
    check_variables 2> $TMP_FOLDER/testNoVariables
    check_variables_status=$?
    check_variables_message=$(cat $TMP_FOLDER/testNoVariables)
    assertEquals "1" "$check_variables_status"
    assertEquals "Image maintainer not provided." "$check_variables_message"
}

testWithDOCKER_IMAGES_MAINTAINER() {
    DOCKER_IMAGES_MAINTAINER="Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>"
    check_variables 2> $TMP_FOLDER/testNoVariables
    check_variables_status=$?
    check_variables_message=$(cat $TMP_FOLDER/testNoVariables)
    assertEquals "1" "$check_variables_status"
    assertEquals "Docker hub organization name not provided." "$check_variables_message"
}

testWithoutDOCKERHUBUSER() {
    DOCKER_ORGANIZATION_NAME="daedalusproject"
    DOCKER_IMAGES_MAINTAINER="Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>"
    check_variables 2> $TMP_FOLDER/testNoVariables
    check_variables_status=$?
    check_variables_message=$(cat $TMP_FOLDER/testNoVariables)
    assertEquals "1" "$check_variables_status"
    assertEquals "Docker hub user not provided." "$check_variables_message"
}

testWithoutDOCKERHUBPASSWORD() {
    DOCKER_ORGANIZATION_NAME="daedalusproject"
    DOCKER_IMAGES_MAINTAINER="Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>"
    DOCKERHUBUSER="myuser"
    check_variables 2> $TMP_FOLDER/testNoVariables
    check_variables_status=$?
    check_variables_message=$(cat $TMP_FOLDER/testNoVariables)
    assertEquals "1" "$check_variables_status"
    assertEquals "Docker hub password not provided." "$check_variables_message"
}

testWithoutIMAGENAME() {
    DOCKER_ORGANIZATION_NAME="daedalusproject"
    DOCKER_IMAGES_MAINTAINER="Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>"
    DOCKERHUBUSER="myuser"
    DOCKERHUBPASSWORD="somepassword"
    check_variables 2> $TMP_FOLDER/testNoVariables
    check_variables_status=$?
    check_variables_message=$(cat $TMP_FOLDER/testNoVariables)
    assertEquals "1" "$check_variables_status"
    assertEquals "IMAGENAME env variable is not set." "$check_variables_message"
}

testAllVariablesSet() {
    DOCKER_ORGANIZATION_NAME="daedalusproject"
    DOCKER_IMAGES_MAINTAINER="Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>"
    DOCKERHUBUSER="myuser"
    DOCKERHUBPASSWORD="somepassword"
    IMAGENAME="SomeImage"
    check_variables 2> $TMP_FOLDER/testNoVariables
    check_variables_status=$?
    check_variables_message=$(cat $TMP_FOLDER/testNoVariables)
    assertEquals "0" "$check_variables_status"
    assertEquals "" "$check_variables_message"
}

# Load shUnit2.
. /usr/bin/shunit2
