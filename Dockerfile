FROM maven:3.8-openjdk-11-slim
ENV dhhost = 172.31.23.200:8123
ENV dhuser = jenkins
ENV dhpass = 1234Jenkins
RUN apt update -y
RUN apt install -y docker.io git
COPY ./daemon.json /etc/docker/
COPY ./df/Dockerfile /tmp/build/
WORKDIR /tmp/build
