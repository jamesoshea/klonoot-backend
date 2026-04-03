FROM joeakeem/brouter:v1.7.8

WORKDIR brouter

COPY update-script.sh .

RUN chmod a+x ./update-script.sh

RUN apt-get update
RUN apt-get install -y wget

CMD ./update-script.sh;/bin/server.sh