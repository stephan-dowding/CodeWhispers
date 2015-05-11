require 'net/http'
require 'json'

git_branch = `git symbolic-ref --short HEAD`.strip!
uri = URI("http://127.0.0.1:3000/challenge/question/#{git_branch}")
json = JSON.parse(Net::HTTP.get(uri))

the_end = json['start'].to_i

uri = URI("http://127.0.0.1:3000/challenge/answer/#{git_branch}")
response = Net::HTTP.post_form(uri, 'end' => the_end)

if response.kind_of? Net::HTTPSuccess
  puts 'Yay!! got it right! =D'
else
  puts 'Boo! Wrong! :('
end
