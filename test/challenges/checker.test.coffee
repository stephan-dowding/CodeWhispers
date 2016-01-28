chai = require "chai"
subject = require "../../challenges/checker"

expect = chai.expect

describe 'check', ->
  it 'notes that objects are the same', ->
    expect(subject.check({a: 1, b: "hello"},{b: "hello", a:1})).to.be.true

  it 'notes that objects are different', ->
    expect(subject.check({a: 1, b: "hello"},{b: "bye", a:2})).to.be.false

  it 'is happy if the second argument contains extras', ->
    expect(subject.check({a: 1, b: "hello"},{c: "huh?!?", b: "hello", a:1})).to.be.true

  it 'is unhappy if the second argument is missing stuff', ->
    expect(subject.check({a: 1, b: "hello"},{b: "bye"})).to.be.false
