FROM ruby:2.3.1

RUN apt-get update && apt-get install -y libopencv-dev

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install
