FROM jenkins/jenkins:lts-slim

USER root

RUN apt update -qq \
    && apt install -y gnupg2 apt-transport-https \
      ca-certificates gnupg2 software-properties-common sudo \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

RUN echo "deb [arch=amd64] https://download.docker.com/linux/debian stretch \
      stable" > /etc/apt/sources.list.d/docker.list \
      && apt update -qq \
      && apt install -y  docker-ce \
      && rm -rf /var/lib/apt/lists/*

RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

RUN  curl -L https://github.com/docker/compose/releases/download/1.23.2/\
docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose; \
    chmod +x /usr/local/bin/docker-compose

USER jenkins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt 
ENTRYPOINT [ "/sbin/tini", "--", "/usr/local/bin/jenkins.sh" ]