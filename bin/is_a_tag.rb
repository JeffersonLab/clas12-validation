#!/usr/bin/env ruby
# check if a given tag is available in a repo; exit 0 if yes, 1 if no

unless ARGV.length == 2
  $stderr.puts "USAGE: #{$0} [tag] [repo owner]/[repo name]"
  exit 2
end
check_tag, repo = ARGV

api_args = [
  '--silent',
  '-L',
  '-H "Accept: application/vnd.github+json"',
  '-H "X-GitHub-Api-Version: 2022-11-28"',
  "https://api.github.com/repos/#{repo}/tags",
]
tag_list = `curl #{api_args.join ' '} | jq -r '.[].name'`
unless $?.success?
  $stderr.puts "ERROR: failed to get list of tags from #{repo}"
  exit 1
end

exit 1 unless tag_list.include? check_tag
