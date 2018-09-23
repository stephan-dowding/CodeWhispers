import {exec} from 'child_process'
import rp from 'request-promise'
import whisper from './whisper'

let git_branch

const doChallenge = async function(){
  const question = await getQuestion()
  const answer = whisper(question)
  sendAnswer(answer)
}

const CODE_WHISPER_HOST = "codewhispers.org"
const getQuestion = async function(){
  const uri = `http://${CODE_WHISPER_HOST}/challenge/question/${git_branch}`

  return await rp({uri, json: true})
}

const sendAnswer = async function(answer){
  const uri = `http://${CODE_WHISPER_HOST}/challenge/answer/${git_branch}`

  const result = await rp({
    method: 'POST',
    uri,
    body: answer,
    json: true,
    resolveWithFullResponse: true,
    simple: false
  })

  if(result.statusCode === 200) {
     console.log('Yay!! You are done with this round! =D')
  }
  else if(result.statusCode === 303) {
    console.log('Got it right, but trying another...')
    doChallenge()
  }
  else {
    console.log('Boo! Wrong! :(')
    console.log(result.body)
  }
}

const getBranchName = function(){
  return new Promise((resolve, reject) => {
    exec("git symbolic-ref --short HEAD", function(error, stdout, stderr) {
      resolve(stdout.toString().trim())
    })
  })
}
const run = async function(){
  git_branch = await getBranchName()
  console.log(`Running for team: ${git_branch}`)
  console.log()
  doChallenge()
}()
