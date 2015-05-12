require 'net/http'
require 'json'

if ARGV[0] == nil
  puts 'PROPER USAGE: ruby whisper.rb <Question Server IP address>'
  exit 1
end

def doChallenge(git_branch)
  uri = URI("http://#{ARGV[0]}:3000/challenge/question/#{git_branch}")
  json = JSON.parse(Net::HTTP.get(uri))

  the_end = json['start'].to_i

  uri = URI("http://#{ARGV[0]}:3000/challenge/answer/#{git_branch}")
  response = Net::HTTP.post_form(uri, 'end' => the_end)

  if response.kind_of? Net::HTTPSuccess
    puts 'Yay!! got it right! =D'
  elsif response.kind_of? Net::HTTPRedirection
    puts 'Got it right, but do another...'
    doChallenge(git_branch)
  else
    puts 'Boo! Wrong! :('
  end
end

git_branch = `git symbolic-ref --short HEAD`.strip!
doChallenge git_branch
