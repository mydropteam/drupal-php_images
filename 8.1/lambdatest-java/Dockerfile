FROM dropteam/drupal-php:8.1-dev

#RUN mkdir /usr/share/man/man1/
RUN apt-get update && apt-get install -y unzip wget openjdk-11-jre-headless maven

RUN cd / && wget https://downloads.lambdatest.com/tunnel/linux/64bit/LT_Linux.zip && unzip LT_Linux.zip

