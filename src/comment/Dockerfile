FROM ruby:2.2-alpine

ENV APP_HOME /app

RUN mkdir $APP_HOME
WORKDIR $APP_HOME
Copy Gemfile* $APP_HOME/

RUN apk add --no-cache --virtual .build-deps make gcc libc-dev \
&& gem install bundler --no-ri --no-rdoc -v 1.17.3 \
&& bundle install \
&& apk del .build-deps

Copy . $APP_HOME

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

CMD ["puma"]
