FROM ruby:2.2-alpine

ENV APP_HOME /app

RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/

RUN apk add --no-cache --virtual .build-deps make gcc libc-dev \
&& gem install bundler --no-ri --no-rdoc -v 1.17.3 \
&& bundle install \
&& apk del .build-deps



COPY . $APP_HOME

ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292

CMD ["puma"]
