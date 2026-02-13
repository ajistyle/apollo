#
# Copyright 2022 Apollo Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Dockerfile for apollo-configservice（单阶段，避免 Apple Silicon buildx 下 Alpine 阶段触发 Rosetta 问题）
# 1. ./scripts/build.sh
# 2. docker build -f apollo-configservice/src/main/docker/Dockerfile --build-arg VERSION=2.1.0 -t xxx apollo-configservice/target

FROM harborURL/eclipse-temurin:8-jre-jammy
LABEL maintainer="ajityle@github.com"

ARG VERSION=2.1.0
ENV APOLLO_RUN_MODE=Docker
ENV SERVER_PORT=8080

RUN echo "deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse" > /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends procps curl bash tzdata unzip \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && rm -rf /var/lib/apt/lists/*

COPY apollo-configservice-${VERSION}-github.zip /tmp/apollo-configservice.zip
RUN unzip -o /tmp/apollo-configservice.zip -d /apollo-configservice \
    && rm /tmp/apollo-configservice.zip \
    && chmod +x /apollo-configservice/scripts/startup.sh

EXPOSE $SERVER_PORT
CMD ["/apollo-configservice/scripts/startup.sh"]
