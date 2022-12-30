FROM dorowu/ubuntu-desktop-lxde-vnc:focal

ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime

RUN apt-get update
RUN apt-get install -y wget iproute2 net-tools python3-pip iputils-ping expect curl sed
RUN apt-get install -y --no-install-recommends
RUN dpkg-reconfigure --frontend noninteractive tzdata


RUN apt-get install -y less vim dnsutils

# RUN useradd -m molly

# ENV USER=molly

ADD "purevpn/*"  "/home/molly/build/"
RUN dpkg -i /home/molly/build/purevpn_1.2.5_amd64.deb
# RUN sed -i 's/-z  $PID/-z $PID/g' /etc/init.d/purevpn
# RUN sed -i 's/-z $PID/-z "$PID"/g' /etc/init.d/purevpn

RUN apt-get install -y xdg-utils

ADD entrypoint.sh /entrypoint.sh
ADD healthcheck.sh /healthcheck.sh
ADD start-firefox.sh /start-firefox.sh
ADD start-vpn.sh /start-vpn.sh

# CMD ["/entrypoint.sh"]
# CMD bash
ENTRYPOINT ["/entrypoint.sh"]