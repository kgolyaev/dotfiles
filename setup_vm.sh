#! /bin/bash

USERNAME=$1
UNAME=$2
PASSW=$3

if [ -z "${USERNAME}" ]; then
    echo "First argument must be specified."
    exit 1
fi
if [ -z "${UNAME}" ]; then
    UNAME="kogoly"
    echo "Using default username: ${UNAME}"
fi
if [ -z "${PASSW}" ]; then
    PASSW="testPassword1"
    echo "Using default password"
fi

PUBLIC_KEY_FILE_SOURCE="/home/${USERNAME}/id_rsa.pub"
if [ ! -e ${PUBLIC_KEY_FILE_SOURCE} ]; then
    echo "File ${PUBLIC_KEY_FILE_SOURCE} is not found, exiting!"
    exit 1
fi
PRIVATE_KEY_FILE_SOURCE="/home/${USERNAME}/id_rsa"
if [ ! -e ${PRIVATE_KEY_FILE_SOURCE} ]; then
    echo "File ${PRIVATE_KEY_FILE_SOURCE} is not found, exiting!"
    exit 1
fi

# key files will be moved to this destination
PUBLIC_KEY_FILE_DEST="/home/${UNAME}/.ssh/id_rsa.pub"
PRIVATE_KEY_FILE_DEST="/home/${UNAME}/.ssh/id_rsa"

# create user
sudo useradd ${UNAME}
# add user to sudoers
sudo usermod -aG sudo ${UNAME}
# make bash user's default shell
sudo chsh -s /bin/bash ${UNAME}
# reset their password
echo "${UNAME}:${PASSW}" | sudo chpasswd
# create home folder
sudo mkdir /home/${UNAME}
# assign home folder ownership
sudo chown ${UNAME} /home/${UNAME}
# set permissions on home folder
sudo chmod 755 /home/${UNAME}
# create folder for ssh keys
sudo mkdir /home/${UNAME}/.ssh
# assign ownership of ssh folder
sudo chown ${UNAME} /home/${UNAME}/.ssh
# move public and private keys to ssh folder
sudo mv ${PRIVATE_KEY_FILE_SOURCE} ${PRIVATE_KEY_FILE_DEST}
sudo mv ${PUBLIC_KEY_FILE_SOURCE} ${PUBLIC_KEY_FILE_DEST}
# assign ownership of key files
sudo chown ${UNAME} ${PRIVATE_KEY_FILE_DEST} ${PUBLIC_KEY_FILE_DEST}
# chamge permissions on ssh keys and folder
sudo chmod 600 ${PRIVATE_KEY_FILE_DEST}
sudo chmod 644 ${PUBLIC_KEY_FILE_DEST}
sudo chmod 700 /home/${UNAME}/.ssh
# move bashrc file to the user's folder
sudo cp /home/${USERNAME}/.bashrc /home/${UNAME}/.bashrc
sudo chown ${UNAME} /home/${UNAME}/.bashrc
sudo cp /home/${UNAME}/.bashrc /home/${UNAME}/.profile
sudo chown ${UNAME} /home/${UNAME}/.profile

