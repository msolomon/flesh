
# flesh

[![Build Status](https://travis-ci.org/msolomon/flesh.png?branch=master)](https://travis-ci.org/msolomon/flesh)

## Setup

1. Install Postgres 9 (I'm using 9.3 installed via `brew`)
1. Edit config/database.yml "development" to match your Postgres setup
1. Install rvm or rbenv
1. Install Ruby 2.1
1. If using RVM, `rvm use gemset flesh --create`
1. Then run some commands:

```bash
bundle install
rake db:setup db:populate
rake
```
