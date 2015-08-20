chai = require "chai"
subject = require "../../challenges/challenge0"

expect = chai.expect

describe 'challenge0', ->
  it 'returns same start and end number', ->
    challenge = subject.challenge()
    expect(challenge.question.start).to.equal(challenge.answer.end)
