chai = require "chai"
subject = require "../../challenges/challenge3"
challengeUtils = require "../../challenges/challengeUtils"
_ = require "underscore"

expect = chai.expect

describe 'challenge3', ->
  it 'returns a string of FBLR for instructions', ->
    challenge = subject.challenge()
    expect(challenge.question.instructions.length).to.be.above(0)
    _.each challenge.question.instructions, (char) ->
      expect(['F', 'B', 'L', 'R']).to.include(char)

  it 'provides startX and startY as numbers', ->
    challenge = subject.challenge()
    expect(challenge.question.startX).to.be.a('number')
    expect(challenge.question.startY).to.be.a('number')

  it 'provides treasureX and treasureY as numbers', ->
    challenge = subject.challenge()
    expect(challenge.question.treasureX).to.be.a('number')
    expect(challenge.question.treasureY).to.be.a('number')

  it 'provides correct endX and endY', ->
    challenge = subject.challenge()
    q = challenge.question
    a = challenge.answer
    instructions = q.instructions.split('')
    expectedEnd = challengeUtils.calculateEndPosition(instructions, [q.startX, q.startY])
    expect([a.endX, a.endY]).to.deep.equal(expectedEnd)

  it 'marks the treasure as found when it should', ->
    challenge = subject.getChallenge(true)
    q = challenge.question
    a = challenge.answer
    expect(a.treasureFound).to.be.true

  it 'marks the treasure as not found when it should', ->
    challenge = subject.getChallenge(false)
    q = challenge.question
    a = challenge.answer
    expect(a.treasureFound).to.be.false

  it 'places the treasure on the route when found', ->
    challenge = subject.getChallenge(true)
    q = challenge.question
    a = challenge.answer
    instructions = q.instructions.split('')
    route = challengeUtils.calculatePath(instructions, [q.startX, q.startY])

    expect(route).to.contain.something.that.deep.equals([q.treasureX, q.treasureY])

  it 'places the treasure off the route when not found', ->
    challenge = subject.getChallenge(false)
    q = challenge.question
    a = challenge.answer
    instructions = q.instructions.split('')
    route = challengeUtils.calculatePath(instructions, [q.startX, q.startY])

    expect(route).not.to.contain.something.that.deep.equals([q.treasureX, q.treasureY])

  it 'places the treasure on the route dependent on random selection', ->
    challenge = subject.challenge()
    q = challenge.question
    a = challenge.answer
    instructions = q.instructions.split('')
    route = challengeUtils.calculatePath(instructions, [q.startX, q.startY])

    if a.treasureFound
      expect(route).to.contain.something.that.deep.equals([q.treasureX, q.treasureY])
    else
      expect(route).not.to.contain.something.that.deep.equals([q.treasureX, q.treasureY])
