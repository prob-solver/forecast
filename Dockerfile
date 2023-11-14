FROM ruby:2.7.7-slim

RUN apt-get update -qq && apt-get install -y \
curl \
zlib1g-dev \
build-essential \
libssl-dev \
libreadline-dev \
libyaml-dev \
libxml2-dev \
libxslt1-dev \
libcurl4-openssl-dev \
libffi-dev \
default-libmysqlclient-dev \
git \
wget \
vim \
apt-transport-https \
shared-mime-info

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && curl -sL https://deb.nodesource.com/setup_16.x | bash -

RUN apt-get install -y \
  yarn \
  nodejs


RUN gem install bundler

ENV INSTALL_PATH /fast_export
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

COPY package.json yarn.lock ./
RUN yarn install --ignore-platform


# This will utilize Docker cache layers when an image builds.
# Gems will be cached and bundle install run only when a gem changes
COPY Gemfile Gemfile.lock package.json yarn.lock ./

#RUN mkdir -p ~/.ssh
#COPY bin/install-ssh-key.sh /tmp
#RUN /tmp/install-ssh-key.sh


# Want binstubs available so can directly call sidekiq and
# potentially other binaries as command overrides without depending on
# bundle exec.
# This is mainly due for production compatibility assurance.
RUN bundle install


# Copy in everything from the current directory relative to the Dockerfile
COPY . .

# In production reverse proxy Rails with nginx
# This sets up a volume so nginx can read in the assets from
# the Rails Docker image without having to copy them to the Docker host
#VOLUME ["$INSTALL_PATH/public"]
# CMD ["./bin/web", "start_staging"]

EXPOSE 3000
ENTRYPOINT ["./bin/docker-entrypoint.sh"]
