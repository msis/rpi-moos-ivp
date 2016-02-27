FROM resin/rpi-raspbian:jessie
MAINTAINER Mohamed Saad IBN SEDDIK <ms.ibnseddik@gmail.com> (@msibnseddik)

RUN apt-get update \
  && apt-get upgrade -y --no-install-recommends \
  && apt-get install \
            build-essential \
            cmake \
            -y --no-install-recommends \
  && apt-get autoremove -y \
  && apt-get clean

# create a sudoer user "moosuser" w/ toor as a password
RUN useradd moosuser -G sudo -m \
  && echo "moosuser:toor" | chpasswd

# get moos-ivp
WORKDIR /home/moosuser/
RUN svn co --non-interactive --trust-server-cert \
  https://oceanai.mit.edu/svn/moos-ivp-aro/trunk/ \
  moos-ivp

# Building MOOS-IvP
WORKDIR /home/moosuser/moos-ivp
# Build & Install MOOS
RUN bash build-moos.sh install
# Build & Install IvP
RUN bash build-ivp.sh -m install

USER moosuser
ENV HOME /home/moosuser
WORKDIR /home/moosuser
