FROM ubuntu:16.04
RUN apt-get update

# Basic utilities
RUN apt-get install -y build-essential python
RUN apt-get install -y apt-utils net-tools curl wget iputils-ping lsof
RUN apt-get install -y git
RUN apt-get install -y vim
RUN apt-get install -y ffmpeg
RUN apt-get install -y sudo
RUN apt-get install -y unzip # needed for ./configure

COPY trunk /root/trunk
WORKDIR /root/trunk

RUN ./configure && make
COPY srs.conf srs-custom.conf
CMD ./objs/srs -c srs-custom.conf && tail -f ./objs/srs.log -f localServer.log