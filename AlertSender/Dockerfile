FROM ruby:2.7.3-alpine
ENV BUNDLER_VERSION=2.2.21
RUN apk add --update --no-cache \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      nodejs \
      openssl \
      pkgconfig \
      postgresql-dev \
      tzdata \
      yarn 
RUN gem install bundler -v 2.2.21
WORKDIR /app
COPY Gemfile ./
RUN bundle check || bundle install
COPY . ./
