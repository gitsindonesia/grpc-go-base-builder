FROM ubuntu:bionic AS builder

RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    wget \
    gnupg-agent

ARG TARGETARCH

RUN wget http://github.com/golang-migrate/migrate/releases/latest/download/migrate.linux-${TARGETARCH}.deb
RUN dpkg -i migrate.linux-${TARGETARCH}.deb
RUN WAIT_FOR_VERSION=v2.2.3 && \
    wget -qO/bin/wait-for https://github.com/eficode/wait-for/releases/download/${WAIT_FOR_VERSION}/wait-for && \
    chmod +x /bin/wait-for

FROM golang:1.22-alpine
ENV GODOG_VERSION=v0.12.6
ENV GOIMPORTS_VERSION=v0.7.0
RUN apk update && apk add --no-cache git \
    make \
    bash \
    alpine-sdk
RUN go install github.com/boumenot/gocover-cobertura@latest
RUN go install github.com/cucumber/godog/cmd/godog@${GODOG_VERSION}
RUN go install golang.org/x/tools/cmd/goimports@${GOIMPORTS_VERSION}
COPY --from=builder /usr/bin/migrate /usr/local/bin/migrate
COPY --from=builder /bin/wait-for /usr/local/bin/wait-for