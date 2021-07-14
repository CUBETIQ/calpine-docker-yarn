FROM cubetiq/calpine-os-linux:latest
LABEL maintainer="sombochea@cubetiqs.com"

# Build with root access
USER root

RUN apk add --no-cache \
		ca-certificates \
		openssh-client

RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf

ENV DOCKER_VERSION 20.10.7

RUN mkdir -p /usr/local/bin

RUN set -eux; \
	\
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		'x86_64') \
			url='https://download.docker.com/linux/static/stable/x86_64/docker-20.10.7.tgz'; \
			;; \
		'armhf') \
			url='https://download.docker.com/linux/static/stable/armel/docker-20.10.7.tgz'; \
			;; \
		'armv7') \
			url='https://download.docker.com/linux/static/stable/armhf/docker-20.10.7.tgz'; \
			;; \
		'aarch64') \
			url='https://download.docker.com/linux/static/stable/aarch64/docker-20.10.7.tgz'; \
			;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;; \
	esac; \
	\
	wget -O docker.tgz "$url"; \
	\
	tar --extract \
		--file docker.tgz \
		--strip-components 1 \
		--directory /usr/local/bin/ \
	; \
	rm docker.tgz; \
	\
	dockerd --version; \
	docker --version

COPY modprobe.sh /usr/local/bin/modprobe
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/modprobe

# Install Yarn
RUN apk add --update --no-cache yarn git

ENV DOCKER_TLS_CERTDIR=/certs
RUN mkdir /certs /certs/client && chmod 1777 /certs /certs/client

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]