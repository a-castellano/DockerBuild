#!/bin/bash -
#===============================================================================
#
#          FILE: 01-debug.sh
#
#   DESCRIPTION: Test debug

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 04/25/2019 07:26
#===============================================================================

source lib/build_docker_image_functions.sh

TearDown() {
    unset DEBUG
}

testDebugNoMessage() {
    no_menssage=$(debug "This is a test")
    assertEquals "$no_menssage" "" #If debug options is not enabled no message is printed
}

testDebugWithMessage() {
    DEBUG=1
    menssage=$(debug "This is a test")
    assertSame "$menssage" "This is a test" #If debug options is not enabled no message is printed
}

# Load shUnit2.
. /usr/bin/shunit2
