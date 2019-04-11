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

RUN apt-get install -y nginx
RUN rm /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/sites-enabled/nginx
RUN service nginx reload
COPY trunk /root/trunk
WORKDIR /root/trunk

RUN ./configure && make
COPY srs.conf srs-custom.conf
CMD sed -i "s,\[ON_PUBLISH_ENDPOINT\],$ON_PUBLISH_ENDPOINT,g" srs-custom.conf && \
    sed -i "s,\[ON_CONNECT_ENDPOINT\],$ON_CONNECT_ENDPOINT,g" srs-custom.conf && \
    sed -i "s,\[ON_UNPUBLISH_ENDPOINT\],$ON_UNPUBLISH_ENDPOINT,g" srs-custom.conf && \
    sed -i "s,\[HTTP_URL\],$HTTP_URL,g" srs-custom.conf && \
    ./objs/srs -c srs-custom.conf && \
    tail -f ./objs/srs.log -f localServer.log