FROM ruby:2.3.2
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN useradd rails -d /home/rails \
    && mkdir -p /home/rails \
    && chown rails.rails -R /home/rails

EXPOSE 3000

USER rails
WORKDIR /home/rails

# Nodebrew
RUN curl -L git.io/nodebrew | perl - setup
ENV PATH /home/rails/.nodebrew/current/bin:$PATH
RUN nodebrew install-binary v6.9.1 \
    && nodebrew use v6.9.1 \
    && npm i -g yarn

RUN mkdir -p /home/rails/project/vendor
WORKDIR /home/rails/project

# Install
RUN gem install bundler
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
COPY vendor/package.json vendor/package.json
COPY vendor/yarn.lock vendor/yarn.lock
COPY bin/yarn bin/yarn
RUN bundle install --path vendor/bundle --jobs=4 --without development test
RUN bundle exec bin/yarn

# assets
COPY . /home/rails/project
USER root
RUN chown rails.rails -R tmp log public
USER rails
RUN RAILS_ENV=production bundle exec bin/rails assets:precompile

# log
RUN ln -sfn /dev/stdout log/unicorn_stdout.log
RUN ln -sfn /dev/stderr log/unicorn_stderr.log

CMD RAILS_ENV=production bundle exec bin/rails db:reset
CMD exec bundle exec unicorn_rails -c config/unicorn.rb -E production
