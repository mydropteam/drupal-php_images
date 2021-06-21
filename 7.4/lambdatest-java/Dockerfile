FROM dropteam/drupal-php:7.4-dev

RUN mkdir /usr/share/man/man1/
RUN apt-get update && apt-get install -y unzip wget openjdk-11-jre-headless maven

RUN cd / && wget https://s3.amazonaws.com/lambda-tunnel/LT_Linux.zip && unzip LT_Linux.zip

