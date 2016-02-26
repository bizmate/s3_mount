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

echo "S3 mount provisioning running in : $CSDIR with KEY $S3_KEY SECRET $S3_SECRET on Bucket $S3_BUCKET"

if [[ ${#S3_KEY} -eq 0  || ${#S3_SECRET} -eq 0  || ${#S3_BUCKET} -eq 0 ]]; then
    echo "Please set up the access environment variables as described in README"
    exit
fi


#install required packages
BASE_PACKAGES="build-essential libfuse-dev fuse-utils libxml2-dev mime-support automake libtool git \
    libcurl4-openssl-dev vsftpd"

# checks if any packages are missing
dpkg -s $BASE_PACKAGES > /dev/null

if [ $? -ne 0 ]; then
    echo "Installing packages : $BASE_PACKAGES"
    sudo apt-get -y update
    sudo apt-get -y install $BASE_PACKAGES
else
    echo "Packages : $BASE_PACKAGES already installed"
fi

# install s3fs
if [ ! -f /usr/bin/s3fs ]; then
    echo "installing s3fs "
    cd ~
    /usr/bin/git clone https://github.com/s3fs-fuse/s3fs-fuse
    cd s3fs-fuse/
    ./autogen.sh
    ./configure --prefix=/usr --with-openssl # See (*1)
    make
    sudo make install
else
    echo "s3fs already installed"
fi

# add auth information for S3 with correct permissions
echo "Adding keys $S3_KEY:$S3_SECRET"
echo "$S3_KEY:$S3_SECRET" > ~/.passwd-s3fs
chmod 600 ~/.passwd-s3fs

if [ ! -f  ~/.passwd-s3fs ]; then
    echo "S3 password file not created ERROR"
    exit 1
fi

/bin/mountpoint /s3mnt > /dev/null

if [ $? -ne 0 ]; then
    # Preparing S3  folders
    sudo mkdir -p /s3mnt
    sudo mkdir -p /tmp/cache
    sudo chmod 777 /tmp/cache /s3mnt

    # Unmount `sudo fusermount -u /s3mnt/`
    # Mounting S3 resouce
    s3fs -o use_cache=/tmp/cache -o use_rrs -o allow_other $S3_BUCKET /s3mnt
    echo "Mounted on /s3mnt"
else
    echo "Mountpoint /s3mnt already set up"
fi

/bin/mountpoint /home/vagrant/ftpfiles > /dev/null
# ftp folder mount
if [[ ! -d /home/vagrant/ftpfiles || $? -ne 0 ]]; then
    echo "Setting up ftpmount folders"
    mkdir -p /home/vagrant/ftpfiles
    mount --bind /s3mnt /home/vagrant/ftpfiles
else
    echo "ftpmount folders already setup"
fi

# Make sure FTP config is added
sudo cp -f /tmp/vagrant/provision/vsftpd.conf /etc/
sudo service vsftpd restart