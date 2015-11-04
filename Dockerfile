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

# =======================
# Clean up APT when done.
# =======================
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# =============
# Install ruby
# =============

# switch to user go
USER go
ENV HOME /var/go
WORKDIR $HOME

# Install rbenv
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
ENV PATH ~/.rbenv/bin:~/.rbenv/shims:$PATH

# Update rbenv and ruby-build definitions
RUN bash -c "cd ~/.rbenv/ && git pull"
RUN bash -c "cd ~/.rbenv/plugins/ruby-build/ && git pull"

# Install ruby and gems
RUN bash -c "rbenv install $RUBY_VERSION"
RUN bash -c "rbenv global $RUBY_VERSION"

RUN echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc

RUN bash -c "gem install bundler --no-ri --no-rdoc"
RUN bash -c "rbenv rehash"
RUN bash -c "ruby -v"
