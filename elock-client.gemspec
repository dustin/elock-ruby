# -*- mode: ruby -*-

require 'time'

Gem::Specification.new do |s|
  s.name = "elock-client"
  s.version = `git describe`.gsub('-', '.')
  s.date = Time.now.strftime '%Y-%m-%d'
  s.summary = "Ruby client for the elock distributed lock server."
  s.email = "dustin@spy.net"
  s.homepage = "http://github.com/dustin/elock-ruby"
  s.description = "elock-client provides a simple ruby interface to the elock distributed lock server."
  s.has_rdoc = true
  s.authors = ["Dustin Sallings"]
  s.files = ["README.txt", "elock-client.gemspec", "lib/elock-client.rb"]
  s.rdoc_options = ["--main", "README.txt"]
  s.extra_rdoc_files = ["README.txt"]
end
