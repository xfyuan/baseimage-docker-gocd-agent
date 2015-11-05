FROM gocd/gocd-agent:latest

# Set correct environment variables.
ENV RUBY_VERSION 2.2.3

# ===================
# Install basic stuff
# ===================
RUN apt-get -qq update && apt-get -y install build-essential \
  libssl-dev libreadline6-dev libpq-dev libyaml-dev zlib1g-dev \
  # for nokogiri
  libxml2-dev libxslt1-dev \
  # for capybara-webkit
  libqt4-webkit libqt4-dev xvfb \
  # for js runtime
  nodejs

# =============
# Install ruby
# =============

# rvm
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3; \curl -sSL https://get.rvm.io | sudo bash -s stable
ONBUILD RUN bash -c "source /etc/profile.d/rvm.sh"
RUN bash -c "source /etc/profile.d/rvm.sh"
RUN bash -c "rvm install $RUBY_VERSION"
RUN bash -c "echo 'gem: --no-ri --no-rdoc' > ~/.gemrc"
RUN bash -c "echo 'gem: --no-ri --no-rdoc' > /var/go/.gemrc"
RUN bash -c "gem install bundler --no-ri --no-rdoc"
RUN bash -c "rvm use $RUBY_VERSION --default"
RUN bash -c "ruby -v"

# =======================
# Clean up APT when done.
# =======================

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

