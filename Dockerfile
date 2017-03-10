FROM alpine

ENV CLI_VERSION=0.4.1
ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.9.1
ENV DOCKER_SHA256 4a9766d99c6818b2d54dc302db3c9f7b352ad0a80a2dc179ec164a3ba29c2d3e

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
