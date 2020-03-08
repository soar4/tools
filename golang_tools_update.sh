#!/bin/bash

set -e
if [ ${#GOPATH} -lt 1 ]; then
    echo "GOPATH not exist. GOPATH:$GOPATH"
    exit 1
fi

fecho() {
    echo "`date '+%Y%m%d %H:%M:%S'` $@"
}

GODIR="$GOPATH/src/golang.org/x"
mkdir -p $GODIR || exit 1
cd $GODIR || exit 1

UpdatePackage() {
    local prj="$1"
    if [ ! -d "$GODIR/$prj" ]; then
        fecho "$GODIR/$prj not exit. exec git clone https://github.com/golang/${prj}.git"
        cd $GODIR || exit 1
        git clone https://github.com/golang/${prj}.git
    fi
    fecho "updating $GODIR/$prj ..."
    cd $GODIR/$prj || exit 1
    git pull
    cd - || exit 1
}

UpdatePackage net
UpdatePackage sync
UpdatePackage tools
UpdatePackage xerrors
UpdatePackage oauth2
UpdatePackage crypto
UpdatePackage sys
UpdatePackage mod

InstallGoPkg() {
    local pkg="$1"
    fecho "go install $pkg"
    go install "$pkg"
}

InstallGoPkg golang.org/x/tools/cmd/auth/gitauth
InstallGoPkg golang.org/x/tools/cmd/auth/cookieauth
InstallGoPkg golang.org/x/tools/cmd/auth/authtest
InstallGoPkg golang.org/x/tools/cmd/auth/netrcauth
InstallGoPkg golang.org/x/tools/cmd/benchcmp
InstallGoPkg golang.org/x/tools/cmd/bundle
InstallGoPkg golang.org/x/tools/cmd/callgraph
InstallGoPkg golang.org/x/tools/cmd/compilebench
InstallGoPkg golang.org/x/tools/cmd/cover
InstallGoPkg golang.org/x/tools/cmd/digraph
InstallGoPkg golang.org/x/tools/cmd/eg
InstallGoPkg golang.org/x/tools/cmd/fiximports
InstallGoPkg golang.org/x/tools/cmd/getgo
InstallGoPkg golang.org/x/tools/cmd/go-contrib-init
InstallGoPkg golang.org/x/tools/cmd/godex
InstallGoPkg golang.org/x/tools/cmd/godoc
InstallGoPkg golang.org/x/tools/cmd/goimports
InstallGoPkg golang.org/x/tools/cmd/gomvpkg
InstallGoPkg golang.org/x/tools/cmd/gorename
InstallGoPkg golang.org/x/tools/cmd/gotype
InstallGoPkg golang.org/x/tools/cmd/goyacc
InstallGoPkg golang.org/x/tools/cmd/guru
InstallGoPkg golang.org/x/tools/cmd/html2article
InstallGoPkg golang.org/x/tools/cmd/present
InstallGoPkg golang.org/x/tools/cmd/splitdwarf
InstallGoPkg golang.org/x/tools/cmd/ssadump
InstallGoPkg golang.org/x/tools/cmd/stress
InstallGoPkg golang.org/x/tools/cmd/stringer
InstallGoPkg golang.org/x/tools/cmd/toolstash

fecho "update success"

