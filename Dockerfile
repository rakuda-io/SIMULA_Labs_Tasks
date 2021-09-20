FROM ruby:2.7.2

# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
#     echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y nodejs yarn vim

RUN mkdir /syllabus
WORKDIR /syllabus
COPY Gemfile /syllabus/Gemfile
COPY Gemfile.lock /syllabus/Gemfile.lock
RUN bundle install

# COPY entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]