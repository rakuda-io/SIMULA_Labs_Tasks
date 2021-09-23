FROM ruby:2.7.2

RUN apt-get update && apt-get install -y nodejs yarn vim mariadb-client

RUN mkdir syllabus
WORKDIR /syllabus
COPY Gemfile Gemfile.lock /syllabus/
RUN bundle install --jobs 4

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]