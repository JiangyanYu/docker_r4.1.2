FROM bioconductor/bioconductor_docker:RELEASE_3_14

MAINTAINER Jiangyan Yu <jiangyan.yu@uni-bonn.de>

# This will make apt-get install without question
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get clean all && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
            apt-utils\
            build-essential \
            gdal-bin \
            libbz2-dev \
            libcairo2-dev \
            libcurl4-gnutls-dev \
            libffi-dev \
            libfreetype*-dev \
            libgdal-dev \
            libgit2-28 \
            libglu1-mesa-dev \
            libglpk40 \
            libgsl-dev \
            libgtk2.0-dev \
            libhdf5-dev \
            liblzma-dev \
            libpng*-dev \
            libproj-dev \
            libssl-dev \
            libudunits2-dev \
            libx11-dev \
            libxml2-dev \
            libxslt1-dev \
            libxt-dev \
            p7zip \
            proj-bin \
            python3.9 \
            python-dev \
            python3-dev \
            python3-pip \
            python3.9-dev \
            xauth \
            xfonts-base \
            xorg \
            xvfb \
            zlib1g-dev \
    && apt-get clean all && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


COPY user-settings /home/rstudio/.rstudio/monitored/user-settings/user-settings
COPY .Rprofile /home/rstudio/

## following are copied from Jonas Schrepping dDockerfile
# update pip
RUN pip3 install --upgrade pip

# install MACS3
RUN pip3 install MACS3==3.0.0a6 

# install cellphonedb
RUN pip3 install cellphonedb==3.0.0

# install scanpy
RUN pip3 install scanpy==1.8.2

# install scvelo
RUN pip3 install scvelo==0.2.4

# install cellrank
RUN pip3 install cellrank==1.5.1

# install scrublet
RUN pip3 install scrublet==0.2.3

## r packages that were installed in my PC
# install cran/bioc packages
ADD docker_install_CranBioc.R /tmp/
RUN R -f /tmp/docker_install_CranBioc.R

## following are copied from Jonas Schrepping dDockerfile
# install bioc data bases
ADD docker_install_Biodb.R /tmp/
RUN R -f /tmp/docker_install_Biodb.R

# install github packages
ADD docker_install_Github.R /tmp/
RUN R -f /tmp/docker_install_Github.R

# install future packages
ADD docker_install_Future.R /tmp/
RUN R -f /tmp/docker_install_Future.R
