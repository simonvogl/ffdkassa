FROM debian:stable-slim

# ENV variables
ENV DEBIAN_FRONTEND noninteractive
ENV TZ "America/New_York"
ENV CUPSADMIN admin
ENV CUPSPASSWORD password

# Install dependencies
RUN apt-get update -qq  && apt-get upgrade -qqy \
    && apt-get install -qqy \
    apt-utils \
    usbutils \
    cups \
    cups-filters \
    printer-driver-all \
    printer-driver-cups-pdf \
    printer-driver-foo2zjs \
    foomatic-db-compressed-ppds \
    openprinting-ppds \
    hpijs-ppds \
    hp-ppd \
    hplip \
    avahi-daemon \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 631
EXPOSE 5353/udp

# Baked-in config file changes
RUN sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf && \
    sed -i 's/Browsing Off/Browsing On/' /etc/cups/cupsd.conf && \
    sed -i 's/<Location \/>/<Location \/>\n  Allow All/' /etc/cups/cupsd.conf && \
    sed -i 's/<Location \/admin>/<Location \/admin>\n  Allow All\n  Require user @SYSTEM/' /etc/cups/cupsd.conf && \
    sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n  Allow All/' /etc/cups/cupsd.conf && \
    echo "ServerAlias *" >> /etc/cups/cupsd.conf && \
    echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf
# install epson drivers
RUN wget https://ftp.epson.com/drivers/pos/tmx-cups-2.0.2.101.tar.gz -P /etc/
RUN tar -xzf /etc/tmx-cups-2.0.2.101.tar.gz -C /etc
RUN dpkg -i /etc/tmx-cups/backend/pcs-3.15.0.0-1.amd64.deb
RUN dpkg -i /etc/tmx-cups/backend/tmx-cups-backend-1.2.3.0-1.amd64.deb
RUN dpkg -i --force-all /etc/tmx-cups/filter/tmx-cups_1.2.2-1_amd64.deb
RUN gunzip /etc/tmx-cups/ppd/tm-impact-receipt-rastertotmu.ppd.gz
RUN cp /etc/tmx-cups/ppd/tm-impact-receipt-rastertotmu.ppd /usr/share/cups/model
RUN /etc/init.d/cups restart
#install printserver 
RUN apt update && apt install default-jre cups-bsd -y
RUN mkdir /etc/ordersprinter
RUN wget https://www.ordersprinter.de/ordersprinter-2_8_20.zip -P /etc/ordersprinter
RUN unzip /etc/ordersprinter/ordersprinter-2_8_20.zip -d /etc/ordersprinter
COPY ./config1.json /etc/ordersprinter/printserver/javaprinter/config1.json
COPY ./config2.json /etc/ordersprinter/printserver/javaprinter/config2.json
COPY ./config3.json /etc/ordersprinter/printserver/javaprinter/config3.json
# back up cups configs in case used does not add their own

RUN cp -rp /etc/cups /etc/cups-bak
VOLUME [ "/etc/cups" ]
VOLUME [ "/usr/share/cups/model" ]
VOLUME [ "/etc/tmx-cups" ]
VOLUME [ "/etc/ordersprinter"]
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
