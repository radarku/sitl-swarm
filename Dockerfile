FROM ubuntu:18.04
LABEL maintainer Kyle Usbeck

# Trick to get apt-get to not prompt for timezone in tzdata
ENV DEBIAN_FRONTEND=noninteractive

# Need Git to checkout our sources
RUN apt-get update && apt-get install -y git

# Need sudo and lsb-release for the installation prerequisites
RUN apt-get install -y sudo lsb-release tzdata bc

# Now grab ArduPilot from GitHub
RUN git clone https://github.com/ArduPilot/ardupilot.git ardupilot
RUN cp -r ardupilot copter
RUN cp -r ardupilot rover
RUN cp -r ardupilot sub

# Build the COPTER
WORKDIR /copter

# Checkout the latest Copter
RUN git checkout Copter-4.0

# Now start build instructions from http://ardupilot.org/dev/docs/setting-up-sitl-on-linux.html
RUN git submodule update --init --recursive

# Need USER set so usermod does not fail...
# Install all prerequisites now
RUN USER=nobody apt-get -y install software-properties-common
RUN USER=nobody apt-add-repository universe
RUN apt-get update
#RUN USER=nobody Tools/scripts/install-apt-ci.sh
RUN USER=nobody apt-get -y install build-essential gawk genromfs libc6-i386 libxml2-dev libxslt1-dev python-pip python-dev zlib1g-dev cmake cmake-data wget
RUN USER=nobody Tools/scripts/configure-ci.sh

# Continue build instructions from https://github.com/ArduPilot/ardupilot/blob/master/BUILD.md
RUN ./waf distclean
RUN ./waf configure --board sitl
RUN ./waf copter

RUN cp build/sitl/bin/arducopter /

COPY copter.parm /copter/Tools/autotest/default_params/copter.parm

# TCP 5760 is what the sim exposes by default, each INSTANCE increments by 10
EXPOSE 5760-7760

# Variables for simulator
ENV INSTANCE 0
ENV LAT 42.3898
ENV LON -71.1476
ENV ALT 14
ENV DIR 270
ENV COPTERMODEL +
ENV ROVERMODEL +
ENV SUBMODEL +
ENV PLANEMODEL +
ENV SPEEDUP 1
ENV VEHICLE arducopter
ENV NUMCOPTERS 0
ENV NUMROVERS 0
ENV NUMSUBS 0
ENV NUMPLANES 0
ENV INCREMENTSTEPLAT 0.01
ENV INCREMENTSTEPLON 0.01

# Finally the command
RUN apt-get install -y screen
COPY startArdu.sh /startArdu.sh
ENTRYPOINT /startArdu.sh ${NUMCOPTERS} ${NUMROVERS} ${NUMSUBS} ${NUMPLANES} ${LAT} ${LON} ${ALT} ${DIR} ${INCREMENTSTEPLAT} ${INCREMENTSTEPLON} ${COPTERMODEL} ${ROVERMODEL} ${SUBMODEL} ${PLANEMODEL} ${SPEEDUP}
