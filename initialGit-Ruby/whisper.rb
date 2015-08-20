require 'net/http'
require 'json'



def doChallenge
  question = getQuestion

  start = question['start']

  answer = {end: start}

  sendAnswer(answer)
end




def getQuestion
  uri = URI("http://codewhispers.cloudapp.net/challenge/question/#{@git_branch}")
  JSON.parse(Net::HTTP.get(uri))
end

def sendAnswer(answer)
  uri = URI("http://codewhispers.cloudapp.net/challenge/answer/#{@git_branch}")

  json_headers = {"Content-Type" => "application/json",
                "Accept" => "application/json"}
  http = Net::HTTP.new(uri.host, uri.port)

  response = http.post(uri.path, answer.to_json, json_headers)

  if response.kind_of? Net::HTTPSuccess
    puts 'Yay!! got it right! =D'
  elsif response.kind_of? Net::HTTPRedirection
    puts 'Got it right, but do another...'
    doChallenge
  else
    puts 'Boo! Wrong! :('
    puts response.body
    exit 1
  end
end

@git_branch = `git symbolic-ref --short HEAD`.strip
doChallenge
