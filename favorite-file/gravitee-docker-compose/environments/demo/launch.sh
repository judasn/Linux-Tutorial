#!/bin/bash
#-------------------------------------------------------------------------------
# Copyright (C) 2015 The Gravitee team (http://gravitee.io)
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#            http://www.apache.org/licenses/LICENSE-2.0
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#-------------------------------------------------------------------------------

readonly WORKDIR="$HOME/graviteeio-demo"
readonly DIRNAME=`dirname $0`
readonly PROGNAME=`basename $0`
readonly color_title='\033[32m'
readonly color_text='\033[1;36m'

# OS specific support (must be 'true' or 'false').
declare cygwin=false
declare darwin=false
declare linux=false
declare dc_exec="docker-compose -f docker-compose-local.yml up"

welcome() {
    echo
    echo -e " ${color_title}  _____ _____       __      _______ _______ ______ ______   _____ ____   \033[0m"
    echo -e " ${color_title} / ____|  __ \     /\ \    / /_   _|__   __|  ____|  ____| |_   _/ __ \  \033[0m"
    echo -e " ${color_title}| |  __| |__) |   /  \ \  / /  | |    | |  | |__  | |__      | || |  | | \033[0m"
    echo -e " ${color_title}| | |_ |  _  /   / /\ \ \/ /   | |    | |  |  __| |  __|     | || |  | | \033[0m"
    echo -e " ${color_title}| |__| | | \ \  / ____ \  /   _| |_   | |  | |____| |____ _ _| || |__| | \033[0m"
    echo -e " ${color_title} \_____|_|  \_\/_/    \_\/   |_____|  |_|  |______|______(_)_____\____/  \033[0m"
    echo -e " ${color_title}    | |                                              \033[0m${color_text}http://gravitee.io\033[0m"
    echo -e " ${color_title}  __| | ___ _ __ ___   ___                                               \033[0m"
    echo -e " ${color_title} / _\` |/ _ \ '_ \` _ \ / _ \                                              \033[0m"
    echo -e " ${color_title}| (_| |  __/ | | | | | (_) |                                             \033[0m"
    echo -e " ${color_title} \__,_|\___|_| |_| |_|\___/                                              \033[0m"
    echo
}

init_env() {
    local dockergrp
    # define env
    case "`uname`" in
        CYGWIN*)
            cygwin=true
            ;;

        Darwin*)
            darwin=true
            ;;

        Linux)
            linux=true
            ;;
    esac

    # test if docker must be run with sudo
    dockergrp=$(groups | grep -c docker)
    if [[ $darwin == false && $dockergrp == 0 ]]; then
        dc_exec="sudo $dc_exec";
    fi
}

init_dirs() {
    echo "Init log directory in $WORKDIR ..."
    mkdir -p "$WORKDIR/logs/"
    echo 
}

main() {
    welcome
    init_env
    if [[ $? != 0 ]]; then
        exit 1
    fi
    set -e
    init_dirs
    pushd $WORKDIR > /dev/null
        echo "Download docker compose files ..."
        curl -L https://raw.githubusercontent.com/gravitee-io/gravitee-docker/master/environments/demo/common.yml -o "common.yml"
        curl -L https://raw.githubusercontent.com/gravitee-io/gravitee-docker/master/environments/demo/docker-compose-local.yml -o "docker-compose-local.yml"
        echo
        echo "Launch GraviteeIO demo ..."
        $dc_exec
    popd > /dev/null
}

main
