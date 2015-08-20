chai = require "chai"
subject = require "../../challenges/challenge1"
_ = require "underscore"

expect = chai.expect

describe 'challenge1', ->
  it 'returns a string of F for instructions', ->
    challenge = subject.challenge()
    expect(challenge.question.instructions.length).to.be.above(0)
    _.each challenge.question.instructions, (char) ->
      expect(char).to.equal('F')

  it 'end differs from start by length of instructions', ->
    challenge = subject.challenge()
    q = challenge.question
    a = challenge.answer
    expect(q.start + q.instructions.length).to.equal(a.end)
