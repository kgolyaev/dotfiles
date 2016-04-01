#!/bin/bash

###############################################################################
###
### This script installs Python 2.7.6 and a bunch of other goodies,
### including Google's tensorflow, onto an Azure Ubuntu VM.
###
### Note that you need to make some changes to line 58 below. At this point
### I don't have the time to go back and fill in this blank.
### You will also need to obtain NXServer if you want to use it, see line 72,
###
###############################################################################

sudo apt-get update
sudo apt-get upgrade -y
# install extended python stuff
sudo apt-get install python-dev python-pip
# these are needed for matplotlib
sudo apt-get install libfreetype6-dev libxft-dev
# these are needed for scipy
sudo apt-get install libblas-dev liblapack-dev libatlas-base-dev gfortran
# trying to build tensorflow from scratch
sudo apt-get install swig

# start installing python blocks
sudo pip install numpy
sudo pip install ipython
sudo pip install matplotlib
sudo pip install scipy
sudo pip install pandas

### I had to go the hard way - build tensorflow from source :(

### clone tensorflow
cd ~
git clone --recurse-submodules https://github.com/tensorflow/tensorflow

### installing bazel
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer
sudo apt-get install pkg-config zip g++ zlib1g-dev unzip
wget https://github.com/bazelbuild/bazel/releases/download/0.1.5/bazel-0.1.5-jdk7-installer-linux-x86_64.sh
chmod +x bazel-0.1.5-jdk7-installer-linux-x86_64.sh
./bazel-0.1.5-jdk7-installer-linux-x86_64.sh --user
export PATH="$PATH:$HOME/bin"

### build tensorflow
cd ~/tensorflow
./configure
bazel build -c opt //tensorflow/cc:tutorials_example_trainer
# test that the above worked
bazel-bin/tensorflow/cc/tutorials_example_trainer
# compile pip package
bazel build -c opt //tensorflow/tools/pip_package:build_pip_package
bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
#replace PACKAGE_NAME with contents from the directory, can use tab
sudo pip install /tmp/tensorflow_pkg/PACKAGE_NAME

### test that it worked:
cd ~/tensorflow/tensorflow/models/image/mnist
python convolutional.py --self_test

### installing jupyter
sudo pip install jupyter

# installing firefox and x11
sudo apt-get install firefox
sudo apt-get install xorg

# download and install nxserver, from www.nomachine.com
sudo dpkg -i ./nomachine_5.0.63_1_amd64.deb

