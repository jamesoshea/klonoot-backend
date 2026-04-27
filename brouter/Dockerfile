FROM joeakeem/brouter:v1.7.8

RUN apt-get update
RUN apt-get install -y wget

WORKDIR brouter

COPY update-script.sh .

RUN chmod a+x ./update-script.sh


CMD ./update-script.sh;/bin/server.sh