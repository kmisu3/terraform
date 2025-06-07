FROM alpine:3.16

RUN apk add --no-cache \
    bash \
    curl \
    jq \
    python3 \
    py3-pip \
    git \
    make

# Terraformのインストール
ARG TERRAFORM_VERSION=1.5.7
RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# AWS CLIのインストール
RUN pip3 install --upgrade pip && \
    pip3 install --no-cache-dir awscli

WORKDIR /work

ENTRYPOINT ["/bin/bash"] 