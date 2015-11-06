FROM gocd/gocd-agent:latest

# Set correct environment variables.
ENV RUBY_VERSION 2.2.3

# ===================
# Install basic stuff
# ===================

RUN apt-get -qq update && apt-get install --no-install-recommends -y -qq \
  curl git openssh-client unzip ruby ca-certificates patch gawk g++ gcc make \
  libc6-dev patch libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev \
  automake libtool bison pkg-config libffi-dev libgmp3-dev \
  build-essential libssl-dev libreadline6-dev libpq-dev libyaml-dev zlib1g-dev \
  libxml2-dev libxslt1-dev libqt4-webkit libqt4-dev xvfb nodejs


# =============
# Install ruby
# =============

# switch to user go
USER go
ENV HOME /var/go
WORKDIR $HOME

# rvm
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3; \curl -sSL https://get.rvm.io | bash -s stable
RUN bash -l -c "source /etc/profile.d/rvm.sh"
RUN bash -l -c "rvm install $RUBY_VERSION"
RUN bash -l -c "echo 'gem: --no-document' > ~/.gemrc"
RUN bash -l -c "gem install bundler --no-document"
RUN bash -l -c "rvm use $RUBY_VERSION --default"
RUN bash -l -c "ruby -v"

# =======================
# Clean up APT when done.
# =======================

USER root
ENV HOME /root
WORKDIR $HOME

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

