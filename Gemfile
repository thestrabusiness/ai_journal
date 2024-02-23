source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip

gem "activerecord-postgres_enum"
gem "bootsnap", require: false
gem "clearance", "~> 2.6"
gem "importmap-rails"
gem "neighbor"
gem "pg", "~> 1.1"
gem "puma", "~> 5.6"
gem "rails", "~> 7.0"
gem "ruby-openai"
gem "sprockets-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "tiktoken_ruby"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem "web-console"
end
