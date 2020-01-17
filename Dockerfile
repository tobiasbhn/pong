FROM ruby:2.6.5-alpine

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir /pong
WORKDIR /pong

COPY Gemfile /pong/Gemfile
COPY Gemfile.lock /pong/Gemfile.lock
RUN bundle install

COPY . /pong

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]