# AI Journal

This is the repo for an AI-powered journaling application built with Ruby on
Rails. It has integrations with OpenAI's language model APIs used for analyzing
journal entries and relationships.

## Setup

### Dependencies

1. Ruby 3.1.0
1. PostgreSQL (11+ for pgvector support)
1. [pgvector extension](https://github.com/pgvector/pgvector)
1. OpenAI API Key

### Install and run

1. Make sure you've got Ruby, Postgres and pgvector installed
1. Clone the repo
1. `bundle install`
1.  Generate credentials file with: `rails credentials:edit --environment development`. See `sample_dev_creds.yml` for the values you'll need.
1. `rails db:setup`
1. `bin/dev` to start the web server + tailwind compiler
1. Visit localhost:3000 to see the app
