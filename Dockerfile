FROM ruby:2.6.5

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
  && apt-get install -y \
  locales \ 
  postgresql-client \
  postgresql-server-dev-all \
  nodejs \
  nano \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
  && locale-gen en_US.UTF-8

WORKDIR /eventaservo

RUN gem install bundler
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 2 --retry 3
COPY . .
RUN npm install -g yarn
RUN yarn

# Executa toda vez que o container inicia
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

# Inicia do Rails Server
CMD ["bundle", "exec", "rails", "server", "-b", "ssl://0.0.0.0:3000?key=certs/private.key&cert=certs/certificate.crt"]
