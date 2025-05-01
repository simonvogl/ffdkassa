#!/bin/bash -ex

if [ $(grep -ci $CUPSADMIN /etc/shadow) -eq 0 ]; then
    useradd -r -G lpadmin -M $CUPSADMIN

    # add password
    echo $CUPSADMIN:$CUPSPASSWORD | chpasswd

    # add tzdata
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
    dpkg-reconfigure --frontend noninteractive tzdata
fi

# restore default cups config in case user does not have any
if [ ! -f /etc/cups/cupsd.conf ]; then
    cp -rpn /etc/cups-bak/* /etc/cups/
fi
/usr/sbin/cupsd -f &
/usr/bin/java -jar /etc/ordersprinter/printserver/javaprinter/javaprinter.jar -configfile=/etc/ordersprinter/printserver/javaprinter/config1.json --mode=cups --cupsprinter=printer1 &
/usr/bin/java -jar /etc/ordersprinter/printserver/javaprinter/javaprinter.jar -configfile=/etc/ordersprinter/printserver/javaprinter/config2.json --mode=cups --cupsprinter=printer2 &
/usr/bin/java -jar /etc/ordersprinter/printserver/javaprinter/javaprinter.jar -configfile=/etc/ordersprinter/printserver/javaprinter/config3.json --mode=cups --cupsprinter=printer3 &
