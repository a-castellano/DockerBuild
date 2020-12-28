#!/bin/bash -
#===============================================================================
#
#          FILE: 02-test_variables.sh
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
    unset DOCKER_REGISTRY_USER
    unset DOCKER_REGISTRY_PASSWORD
    unset IMAGE_NAME
    unset BUILD_PATH
}

testNoVariables() {
    check_variables 2> $TMP_FOLDER/testNoVariables
    check_variables_status=$?
    check_variables_message=$(cat $TMP_FOLDER/testNoVariables)
    assertEquals "1" "$check_variables_status"
    assertEquals "Docker hub organization name not provided." "$check_variables_message"
}

testOnlyImagename() {
    IMAGE_NAME="SomeImage"
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

testWithoutDOCKER_REGISTRY_USER() {
    DOCKER_ORGANIZATION_NAME="daedalusproject"
    DOCKER_IMAGES_MAINTAINER="Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>"
    check_variables 2> $TMP_FOLDER/testNoVariables
    check_variables_status=$?
    check_variables_message=$(cat $TMP_FOLDER/testNoVariables)
    assertEquals "1" "$check_variables_status"
    assertEquals "Registry user not provided." "$check_variables_message"
}

testWithoutDOCKER_REGISTRY_PASSWORD() {
    DOCKER_ORGANIZATION_NAME="daedalusproject"
    DOCKER_IMAGES_MAINTAINER="Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>"
    DOCKER_REGISTRY_USER="myuser"
    check_variables 2> $TMP_FOLDER/testNoVariables
    check_variables_status=$?
    check_variables_message=$(cat $TMP_FOLDER/testNoVariables)
    assertEquals "1" "$check_variables_status"
    assertEquals "Registry user password not provided." "$check_variables_message"
}

testWithoutIMAGE_NAME() {
    DOCKER_ORGANIZATION_NAME="daedalusproject"
    DOCKER_IMAGES_MAINTAINER="Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>"
    DOCKER_REGISTRY_USER="myuser"
    DOCKER_REGISTRY_PASSWORD="somepassword"
    check_variables 2> $TMP_FOLDER/testNoVariables
    check_variables_status=$?
    check_variables_message=$(cat $TMP_FOLDER/testNoVariables)
    assertEquals "1" "$check_variables_status"
    assertEquals "IMAGE_NAME env variable is not set." "$check_variables_message"
}

testAllVariablesSet() {
    DOCKER_ORGANIZATION_NAME="daedalusproject"
    DOCKER_IMAGES_MAINTAINER="Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>"
    DOCKER_REGISTRY_USER="myuser"
    DOCKER_REGISTRY_PASSWORD="somepassword"
    IMAGE_NAME="SomeImage"
    check_variables 2> $TMP_FOLDER/testNoVariables
    check_variables_status=$?
    check_variables_message=$(cat $TMP_FOLDER/testNoVariables)
    assertEquals "0" "$check_variables_status"
    assertEquals "" "$check_variables_message"
}

testBUILD_PATH_unset() {
    DOCKER_ORGANIZATION_NAME="daedalusproject"
    DOCKER_IMAGES_MAINTAINER="Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>"
    DOCKER_REGISTRY_USER="myuser"
    DOCKER_REGISTRY_PASSWORD="somepassword"
    IMAGE_NAME="SomeImage"
    check_variables 2> $TMP_FOLDER/testNoVariables
    check_variables_status=$?
    check_variables_message=$(cat $TMP_FOLDER/testNoVariables)
    assertEquals "0" "$check_variables_status"
    assertEquals "." "$BUILD_PATH"
}

testBUILD_PATH_set() {
    DOCKER_ORGANIZATION_NAME="daedalusproject"
    DOCKER_IMAGES_MAINTAINER="Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>"
    DOCKER_REGISTRY_USER="myuser"
    DOCKER_REGISTRY_PASSWORD="somepassword"
    IMAGE_NAME="SomeImage"
    BUILD_PATH="path"
    check_variables 2> $TMP_FOLDER/testNoVariables
    check_variables_status=$?
    check_variables_message=$(cat $TMP_FOLDER/testNoVariables)
    assertEquals "0" "$check_variables_status"
    assertEquals "path" "$BUILD_PATH"
}


# Load shUnit2.
. /usr/bin/shunit2
