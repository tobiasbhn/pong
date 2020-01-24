# FROM ruby:2.6.5-alpine
# LABEL maintainer="Tobias Bohn <info@tobiasbohn.com>"

# # throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1

# WORKDIR /pong
# COPY Gemfile* ./
# COPY entrypoint.sh /usr/bin/

# RUN apk update \
#     && apk add --no-cache \
#         less \
#         dumb-init \
#         libpq \
#         tzdata \
#         nodejs \
#         yarn \
#         build-base \
#         git \
#         openssh-client \
#         postgresql-dev \
#         bash \
#         chromium \
#         chromium-chromedriver \
#     && rm -rf /var/lib/apt/lists/* \
#     && gem install bundler:2.0.2 \
#     && bundle install \
#     && chmod +x /usr/bin/entrypoint.sh

# ENTRYPOINT ["entrypoint.sh"]
# COPY . .
# EXPOSE 3000

# CMD ["rails", "server", "-b", "0.0.0.0"]



#######################################################################
#  BUILDER  ###########################################################
#######################################################################
FROM ruby:2.6.5-alpine AS builder
MAINTAINER Tobias Bohn <info@tobiasbohn.com>

ARG app_path=/pong/
ARG RAILS_MASTER_KEY=
ENV RAILS_MASTER_KEY ${RAILS_MASTER_KEY}

RUN bundle config --global frozen 1 \
    && apk --no-cache --update add \
        build-base \
        ruby-dev \
        postgresql-dev \
        tzdata \
        nodejs \
        yarn \
        bash \
        git \
    && gem install bundler:2.0.2

WORKDIR ${app_path}
COPY Gemfile* ${app_path}




#######################################################################
#  DEVELOPMENT  #######################################################
#######################################################################
FROM builder AS dev_bundle

RUN bundle install -j4 --retry 3 \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY . ${app_path}


#######################################################################
#######################################################################
FROM ruby:2.6.5-alpine AS development
MAINTAINER Tobias Bohn <info@tobiasbohn.com>

ARG RAILS_MASTER_KEY=
ENV RAILS_MASTER_KEY ${RAILS_MASTER_KEY}

ARG app_path=/pong/
WORKDIR ${app_path}
EXPOSE 3000

COPY entrypoint.sh /usr/bin/

RUN apk --update --no-cache add \
        postgresql-client \
        chromium-chromedriver \
        chromium \
        tzdata \
        bash \
        yarn \
        nodejs \
    && chmod +x /usr/bin/entrypoint.sh

COPY --from=dev_bundle /usr/local/bundle/ /usr/local/bundle/
COPY --from=dev_bundle ${app_path} ${app_path}

ENTRYPOINT ["entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]




#######################################################################
#  PRODUCTION  ########################################################
#######################################################################
FROM builder AS prod_bundle

RUN bundle install --without development test -j4 --retry 3 \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY . ${app_path}
RUN yarn install --check-files \
    && RAILS_ENV=production bundle exec rake assets:precompile \
    && rm -rf node_modules tmp/cache app/assets vendor/assets lib/assets spec


#######################################################################
#######################################################################
FROM ruby:2.6.5-alpine AS production
MAINTAINER Tobias Bohn <info@tobiasbohn.com>

ARG RAILS_MASTER_KEY=
ENV RAILS_MASTER_KEY ${RAILS_MASTER_KEY}
ENV RAILS_ENV production

ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true
ENV EXECJS_RUNTIME Disabled

ARG app_path=/pong/
WORKDIR ${app_path}
EXPOSE 3000

COPY entrypoint.sh /usr/bin/

RUN apk --update --no-cache add \
        postgresql-client \
        tzdata \
        bash \
    && chmod +x /usr/bin/entrypoint.sh

COPY --from=prod_bundle /usr/local/bundle/ /usr/local/bundle/
COPY --from=prod_bundle ${app_path} ${app_path}

ENTRYPOINT ["entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]