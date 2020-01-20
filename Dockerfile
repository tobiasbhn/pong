FROM ruby:2.6.5-alpine

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /pong
COPY Gemfile* ./
COPY entrypoint.sh /usr/bin/

RUN apk update \
    && apk add --no-cache \
        less \
        dumb-init \
        libpq \
        tzdata \
        nodejs \
        yarn \
        build-base \
        git \
        openssh-client \
        postgresql-dev \
        bash \
    && rm -rf /var/lib/apt/lists/* \
    && gem install bundler:2.0.2 \
    && bundle install \
    && chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
COPY . .
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
