FROM ubuntu
#FROM anapsix/alpine-java

MAINTAINER Raghav Kumar Gautam

#RUN apk add --update unzip wget curl docker jq coreutils openssh
RUN apt update
RUN apt install -y unzip wget curl jq coreutils openssh-server net-tools vim docker.io openjdk-8-jdk
RUN apt install -y python-pip
RUN pip install ducktape

ENV KAFKA_VERSION="0.10.0.1" SCALA_VERSION="2.11"
#ADD download-kafka.sh /tmp/download-kafka.sh
#RUN /tmp/download-kafka.sh && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

VOLUME ["/kafka"]

ENV KAFKA_HOME /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ADD start-kafka.sh /usr/bin/start-kafka.sh
ADD broker-list.sh /usr/bin/broker-list.sh
ADD create-topics.sh /usr/bin/create-topics.sh

ADD ssh /root/.ssh
# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
#CMD service ssh start && /usr/bin/start-kafka.sh
CMD service ssh start && (tar xfz /kfk_src/core/build/distributions/kafka_2.10-0.10.2.0-SNAPSHOT.tgz -C /opt || echo missing kafka tgz did you build kafka tarball) && mv /opt/kafka* /opt/kafka-trunk && bash
