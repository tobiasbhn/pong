#######################################################################
#  BASE  ##############################################################
#######################################################################
FROM ruby:2.6.5-alpine AS base
LABEL maintainer="Tobias Bohn <info@tobiasbohn.com>"

ARG APP_PATH=/pong/
ARG RAILS_MASTER_KEY
ENV APP_PATH=$APP_PATH \
    RAILS_MASTER_KEY=$RAILS_MASTER_KEY

WORKDIR $APP_PATH



#######################################################################
#  BUILDER  ###########################################################
#######################################################################
FROM base AS builder

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

COPY Gemfile* $APP_PATH



#######################################################################
#  DEVELOPMENT BUNDLE  ################################################
#######################################################################
FROM builder AS dev_bundle

RUN bundle install -j4 --retry 3 \
    && bundle clean --force \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY . $APP_PATH



#######################################################################
#  PRODUCTION BUNDLE  #################################################
#######################################################################
FROM builder AS prod_bundle

RUN bundle install --without development test -j4 --retry 3 \
    && bundle clean --force \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY . $APP_PATH
RUN yarn install --check-files --prod \
    && RAILS_ENV=production bundle exec rake assets:precompile \
    && rm -rf node_modules tmp/cache app/assets vendor/assets lib/assets spec



#######################################################################
#  DEVELOPMENT FINAL  #################################################
#######################################################################
FROM base AS development

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
COPY --from=dev_bundle $APP_PATH $APP_PATH

RUN yarn install --check-files

ENTRYPOINT ["entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]



#######################################################################
#  PRODUCTION FINAL  ##################################################
#######################################################################
FROM base AS production

ENV RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true \
    EXECJS_RUNTIME=Disabled

EXPOSE 3000
COPY entrypoint.sh /usr/bin/

RUN apk --update --no-cache add \
        postgresql-client \
        tzdata \
        bash \
    && chmod +x /usr/bin/entrypoint.sh

COPY --from=prod_bundle /usr/local/bundle/ /usr/local/bundle/
COPY --from=prod_bundle $APP_PATH $APP_PATH

ENTRYPOINT ["entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]