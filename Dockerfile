FROM ruby:2.3.1
MAINTAINER Ronaldo Jorge Fuzinato

## ENVIRONMENT
ENV PORT=3000
ENV SECRET_KEY_BASE=bd1a300e62c4a2f6d566ce49c2a1b1aaf0de6096ec6e1a994659920e0069be4cef77b1abad6ab03f6f48d4da14537c13e7744558afc8541073eb3c6658579fd6

RUN apt-get update && apt-get install -y \
  libpq-dev \
  build-essential \
  nodejs \
  libgmp3-dev

## GEMS
RUN gem install bundler
RUN mkdir -p /usr/src/votweb
WORKDIR /usr/src/votweb
COPY Gemfile /usr/src/votweb/
COPY Gemfile.lock /usr/src/votweb/
RUN bundle install -V --without development test

## SRC
COPY . /usr/src/votweb

## CLEANUP
RUN apt-get autoremove -y && apt-get autoclean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## RUN
EXPOSE 3000
RUN rake assets:precompile
CMD puma -F config/puma.rb
