FROM maven:3.6-jdk-11
LABEL org.opencontainers.image.authors="arturhooks@gmail.com"
RUN echo "deb [trusted=yes] http://archive.debian.org/debian buster main non-free contrib" > /etc/apt/sources.list
RUN echo "deb-src [trusted=yes] http://archive.debian.org/debian buster main non-free contrib" >> /etc/apt/sources.list
RUN echo "deb [trusted=yes] http://archive.debian.org/debian-security buster/updates main non-free contrib" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y wget curl nano

WORKDIR /usr/src/app
ARG VERSION

# Build server
RUN wget https://github.com/abrensch/brouter/archive/refs/tags/v${VERSION}.tar.gz \
&& tar xzvf v${VERSION}.tar.gz && rm v${VERSION}.tar.gz \
&& cd brouter-${VERSION} && ./gradlew clean build fatJar

# Run server
WORKDIR /data


CMD java -Xmx128M -Xms128M -Xmn8M -XX:+PrintCommandLineFlags -DmaxRunningTime=300 -cp /usr/src/app/brouter-1.7.9/brouter-server/build/libs/brouter-1.7.9-all.jar btools.server.RouteServer segments profiles ../customprofiles 17777 1