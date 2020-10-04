# Base container for Megeno distributed pipeline
FROM continuumio/miniconda3
MAINTAINER shaman.narayanasamy@megeno.com
LABEL version="Draft image for Compression"

USER root
ENV TZ=Europe/Luxembourg
#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

################
# dependencies #
################

RUN mkdir -p /usr/share/man/man1

RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install -y libqt4-dev libqt4-xml libxcb-screensaver0 libavahi-compat-libdnssd1 \
    && apt-get install -y libphonon4 libhunspell-dev parallel \
    && apt-get install -yq make cmake wget build-essential unzip ant git tig vim rsync\
    && apt-get install -yq zlib1g zlib1g-dev bzip2 gzip pigz pbzip2\
    && apt-get install -yq gnupg zip openssl ccrypt \
    && apt-get install -yq fuse libfuse2 \
    && apt-get install -yq autoconf \
    && apt-get install -yq libtool \
    && apt-get install -yq libcurl4-openssl-dev libbz2-dev libssl-dev \
    && apt-get install -yq libc-ares2 gdebi-core \
    && apt-get install -yq libncurses5 libncurses5-dev sudo libatlas-base-dev \
    && apt-get install -yq graphviz libgraphviz-dev graphviz-dev pkg-config \
    && rm -rf /var/lib/apt/lists/* 

######################
# Set up environment #
######################

ADD envs/requirements.yaml /tmp/
RUN conda update --freeze-installed conda \
    && conda env create --file /tmp/requirements.yaml

#conda update -yc defaults conda \
#    && conda env create --file /tmp/requirements.yaml 

##############################
# Install Compressions tools #
##############################

# Deez

RUN git clone https://github.com/sfu-compbio/deez.git \
    && cd deez \
    && make -j

# Quip

RUN git clone git://github.com/dcjones/quip.git \
    && cd quip \
    && autoreconf -i \
    && ./configure \
    && make install 

# Scramble

#RUN wget http://sourceforge.net/projects/staden/files/io_lib/1.14.0/io_lib-1.14.0.tar.gz/download \
RUN wget https://sourceforge.net/projects/staden/files/io_lib/1.14.9/io_lib-1.14.9.tar.gz/download \
    && tar xvzf download \
    && cd io_lib-1.14.9 \
    && ./configure \
    && make install \
    && ldconfig -v 

##############################
# Install Petasuite Protect  #
##############################

## These are some of the erlier versions of petasuite that we tested
#RUN wget -O petasuite-cloud-edition_1.2.6p5_amd64.run 'https://lm.petagene.com/cgi/download.cgi?filename=petasuite-cloud-edition_1.2.6p5_amd64.run&cookie=b01a24f7fbab420ea60ad223c67d0446' \
#RUN wget -O petasuite-cloud-edition_1.2.6p10_amd64.run 'https://lm.petagene.com/cgi/download.cgi?filename=petasuite-cloud-edition_1.2.6p10_amd64.run&cookie=b01a24f7fbab420ea60ad223c67d0446' \
#
RUN wget -O petasuite-cloud-edition_protect_1.3.0p2.bffb9c227.CLOUD_amd64.run 'https://lm.petagene.com/cgi/download.cgi?filename=petasuite-cloud-edition_protect_1.3.0p2.bffb9c227.CLOUD_amd64.run&cookie=b01a24f7fbab420ea60ad223c67d0446' \
    && mv petasuite-cloud-edition_protect_1.3.0p2.bffb9c227.CLOUD_amd64.run /tmp \
    && cd /tmp \
    && chmod u+x /tmp/petasuite-cloud-edition_protect_1.3.0p2.bffb9c227.CLOUD_amd64.run \
    && yes | MORE="-c 100000" /tmp/petasuite-cloud-edition_protect_1.3.0p2.bffb9c227.CLOUD_amd64.run --nox11 \
    && apt-get update \
    && gdebi -n /tmp/petasuite-cloud-edition_1.3.0p2_amd64/petasuite-cloud-edition_1.3.0p2_amd64.deb


# LZ4
RUN git clone https://github.com/lz4/lz4.git \ 
    && mv lz4 /tmp \
    && cd /tmp/lz4 \
    && make \
    && make install 


##############################
# Install Encryption  tools #
##############################

# Cryfa

RUN git clone https://github.com/cobilab/cryfa.git \
    && cd cryfa \
    && cmake . \
    && make

# Crypt4gh

RUN pip install git+https://github.com/EGA-archive/crypt4gh.git

####################
# Add tools paths #
####################

ENV PATH PATH /opt/conda/bin:/opt/conda/envs/compression/bin/:/deez:/cryfa:$PATH
    
# Add Petasuite credentials (and Petasuite Protect)
ENV PETASUITE_REFPATH /references:/opt/petagene/petasuite/species

ENV KMS_URL https://130.61.57.75:50050

ENV CERT_PATH /tmp/shaman.narayanasamy+pptest_megeno.com(Plg5MkGfVS).p12

ENV USER_ID db1c3a9687b2c85c

ENV PROJECT_NAME ingestion

ENV STEWARD_ID Megeno

ADD pp_credentials/shaman.narayanasamy+pptest_megeno.com(Plg5MkGfVS).p12 /tmp
RUN echo "Plg5MkGfVS" | MORE="-c 10000" pgman protect import "${CERT_PATH}" "${KMS_URL}" \
    && pgman protect associate "${USER_ID}" "${PROJECT_NAME}" \ 
    && pgman protect default "${USER_ID}" "${PROJECT_NAME}"

WORKDIR /code 
