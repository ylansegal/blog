ruby File.readlines('.tool-versions').find { |l| l =~ /^ruby/ }.split.last

source "https://rubygems.org"
gem "base64"
gem "csv"
gem "jekyll", "~> 4.1"
gem "jekyll-whiteglass", github: "ylansegal/whiteglass", branch: "deprecation_warnings"
gem "logger"
gem "webrick"

group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.12"
end
