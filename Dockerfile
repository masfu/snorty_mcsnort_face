FROM python:alpine

#Change these values dependant on your environment
ENV MQTT="10.0.0.100" MQTTPORT=1883 NETINT="enp0s3"

RUN pip install --upgrade pip setuptools wheel
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY snort_socket.py .
COPY super_snort.conf .
COPY simple_snort.conf /etc/snort/simple_snort.conf
COPY rules /etc/snort/rules

#Replace apk directories with the latest directories
RUN echo "http://dl-3.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories

RUN apk upgrade --update-cache --available
RUN apk add --no-cache snort daq supervisor

#run processes from Supervisor
ENTRYPOINT ["/usr/bin/supervisord","-c","/super_snort.conf"]
