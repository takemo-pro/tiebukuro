#!/bin/bash

cd /var/www/rails/ && git pull
bundle install --without development test
bin/webpack
rails db:migrate

bundleo exec pumactl start