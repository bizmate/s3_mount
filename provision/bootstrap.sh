#!/usr/bin/env bash

# based on http://tecadmin.net/mount-s3-bucket-centosrhel-ubuntu-using-s3fs/#
# and https://github.com/s3fs-fuse/s3fs-fuse/wiki/Installation-Notesecho
# and https://gist.github.com/jcaddel/730dc58f4653adf33e4f

VAGRANT_PROVISION_FOLDER=/vagrant/provision

if [ -d $VAGRANT_PROVISION_FOLDER ]; then
    CSDIR=$VAGRANT_PROVISION_FOLDER
else
    CSDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
fi

#include generic functions
. "$CSDIR/genericFunctions.sh"


S3_KEY=$(argValue AWS_S3_KEY)
S3_SECRET=$(argValue AWS_S3_SECRET)
S3_BUCKET=$(argValue AWS_S3_BUCKET)

echo "S3 mount provisioning running in : $CSDIR with KEY $S3_KEY SECRET $S3_SECRET"

exit

#install required packages
BASE_PACKAGES="build-essential libfuse-dev fuse-utils libxml2-dev mime-support automake libtool git libcurl4-openssl-dev"

dpkg -s $BASE_PACKAGES > /dev/null

if [ $? -ne 0 ]; then
    echo "Installing packages : $BASE_PACKAGES"
    sudo apt-get -y update
    sudo apt-get -y install $BASE_PACKAGES
else
    echo "Packages : $BASE_PACKAGES already installed"
fi

# Preparing S3  folders
mkdir

# Unmount `sudo fusermount -u /s3mnt/`
# Mounting S3 resouce
s3fs -o use_cache=/tmp/cache waspdocstore /s3mnt