#! /bin/bash

######################################################################
###
### This script was developed to install Python and its components
### on a clean installation of Ubuntu 14.04 LTS (Trusty Tahr).
###
### It requires sudo priviliges, as may become apparent.
### It was tested a couple times on a clean install onto an Oracle
### VirtualBox VM. I do not guarantee it will work for your use case.
###
######################################################################

### update existing software
sudo apt-get update
sudo apt-get upgrade -y -f

# install additional software
sudo apt-get install -y mysql-server
sudo apt-get install -y mysql-client
sudo apt-get install -y default-jdk
sudo apt-get install -y liblzma-dev
sudo apt-get install -y libxml2-dev
sudo apt-get install -y libiodbc2-dev
sudo apt-get install -y libpq-dev
sudo apt-get install -y curl
sudo apt-get install -y libcurl4-openssl-dev

### install sqlite
sudo apt-get install -y sqlite

### install python and modules
sudo apt-get install -y python-dev
sudo apt-get install -y ipython
sudo apt-get install -y ipython-notebook
sudo apt-get install -y python-numpy
sudo apt-get install -y python-matplotlib
sudo apt-get install -y python-scipy
sudo apt-get install -y python-pandas
sudo apt-get install -y python-sympy
sudo apt-get install -y python-rpy
sudo apt-get install -y python-sklearn
sudo apt-get install -y python-nltk
sudo apt-get install -y python-requests
# installing numba takes a bit of extra work
sudo apt-get install -y llvm-3.3-dev
sudo apt-get install -y python-pip
sudo ln -s /usr/bin/llvm-config-3.3 /usr/bin/llvm-config
sudo LLVM_CONFIG_PATH=/usr/bin/llvm-config pip install llvmpy
sudo pip install numba

