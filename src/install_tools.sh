#!/bin/bash

function install_linux
{
wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh .
bash Miniconda2-latest-Linux-x86_64.sh

wget https://repo.anaconda.com/archive/Anaconda2-5.3.0-Linux-x86_64.sh .
bash Anaconda2-5.3.0-Linux-x86_64.sh

wget http://people.virginia.edu/~wc9c/KING/Linux-king.tar.gz .
tar -xvzf Linux-king.tar.gz

conda create -n id_matching python=2.7
source activate id_matching
conda install -c bioconda tabix
conda install -c bioconda plink2
conda install -c bioconda bcftools
}

function install_mac
{
wget https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh .
bash Miniconda3-latest-MacOSX-x86_64.sh

wget https://repo.anaconda.com/archive/Anaconda2-5.3.0-MacOSX-x86_64.pkg .
sudo installer -pkg Anaconda2-5.3.0-MacOSX-x86_64.pkg -target /

wget http://people.virginia.edu/~wc9c/KING/Mac-king.tar.gz .
tar -xvzf Mac-king.tar.gz

conda create -f -n id_matching python=2.7
source activate id_matching
conda install -c bioconda tabix
conda install -c bioconda plink2
conda install -c bioconda bcftools
}

#install_linux
install_mac


