FROM alpine

ENV CLI_VERSION=0.4.1
ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.9.1
ENV DOCKER_SHA256 6a095ccfd095b1283420563bd315263fa40015f1cee265de023efef144c7e52d

RUN apk add --update curl openssl ca-certificates bash && rm -rf /var/cache/apk/*

RUN set -x \
	&& curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
	&& echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
	&& tar -xzvf docker.tgz \
	&& mv docker/* /usr/local/bin/ \
	&& rmdir docker \
	&& rm docker.tgz \
	&& docker -v

ADD https://github.com/rancher/cli/releases/download/v${CLI_VERSION}/rancher-linux-amd64-v${CLI_VERSION}.tar.gz /tmp/cli.tar.gz
RUN tar xvfz /tmp/cli.tar.gz -C /tmp \ 
	&& cp "/tmp/rancher-v${CLI_VERSION}/rancher" /bin/ \
	&& rm -rf /tmp/*

CMD ["bash"]
