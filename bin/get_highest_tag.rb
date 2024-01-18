#!/usr/bin/ruby
# gets the tag with the highest semver number
# - "highest" is preferred over "latest", because of backports to old tags may
#   cause them to be "later" than "higher" tags
# - must be executed in a directory containing `.git/`
# - while this script may not be used in this repository, it may be used by caller workflows

tag_list = `git tag --list`.split.map{ |tag|
  begin
    Gem::Version.new tag
  rescue
    nil
  end
}.compact.sort.reverse.map &:to_s

if tag_list.empty?
  $stderr.puts "ERROR: no semver tags found"
  exit 1
end

puts tag_list.first
