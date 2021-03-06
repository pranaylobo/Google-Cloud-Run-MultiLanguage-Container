FROM ubuntu

#Update all packages
RUN apt-get update

#Install tzdata and set timezone.
ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get -y install tzdata

#Install Software Properties
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*

#Install C/C++ Compiler
RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt update

RUN apt install python3.8

RUN python3 --version

#Install Java Compiler
RUN add-apt-repository -y ppa:openjdk-r/ppa  
RUN apt-get update -y  
RUN apt install -y openjdk-8-jre
RUN apt-get install -y default-jdk

#Install applications
RUN apt-get -y install apache2
RUN apt-get -y install php libapache2-mod-php

#Remove any unnecessary files
RUN apt-get clean

#Setup Apache2 servers                                               
#Debian configuration requires the environment variables APACHE_RUN_USER, APACHE_RUN_GROUP, and APACHE_PID_FILE to be set
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2.pid

RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf


#Start services
# CMD /usr/sbin/apache2ctl -D FOREGROUND

#Copy files to webserver 
COPY Online /var/www/html/

#Change Permission
RUN chmod -R 777 /var/www/html/

# Remove Default index.html
RUN rm /var/www/html/index.html
 
RUN java -version
RUN python3 --version

CMD ["apachectl", "-D", "FOREGROUND"]


