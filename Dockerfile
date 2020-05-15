FROM debian:10

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get -y install ruby-dev gcc make

RUN gem install bundler --no-document

WORKDIR /app
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install --without='development test'
COPY . .

CMD ["puma", ".config.ru", "-b", "tcp://0.0.0.0:80", "-e", "production"]
EXPOSE 80
