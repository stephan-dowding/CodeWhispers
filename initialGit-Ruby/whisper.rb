require 'net/http'
require 'json'

if ARGV[0] == nil
  puts 'PROPER USAGE: ruby whisper.rb <Question Server IP address>'
  exit 1
end

git_branch = `git symbolic-ref --short HEAD`.strip!
uri = URI("http://#{ARGV[0]}:3000/challenge/question/#{git_branch}")
json = JSON.parse(Net::HTTP.get(uri))

the_end = json['start'].to_i

uri = URI("http://#{ARGV[0]}:3000/challenge/answer/#{git_branch}")
response = Net::HTTP.post_form(uri, 'end' => the_end)

if response.kind_of? Net::HTTPSuccess
  puts 'Yay!! got it right! =D'
else
  puts 'Boo! Wrong! :('
end
