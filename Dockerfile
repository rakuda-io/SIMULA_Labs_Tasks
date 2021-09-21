FROM ruby:2.7.2

RUN apt-get update && apt-get install -y nodejs yarn vim

RUN mkdir syllabus
WORKDIR /syllabus
COPY Gemfile /syllabus/
COPY Gemfile.lock /syllabus/
RUN bundle install

COPY / /syllabus/