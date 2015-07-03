chai = require "chai"
subject = require "../../challenges/challengeUtils"

expect = chai.expect

describe 'challengeutils', ->
  describe '#calculatedEndPosition', ->
    it 'adds 1 to X on F', ->
      expect(subject.calculateEndPosition(['F'], [0,0])).to.deep.equal([1,0])
    it 'adds 1 to Y on L', ->
      expect(subject.calculateEndPosition(['L'], [0,0])).to.deep.equal([0,1])
    it 'subtracts 1 from X on B', ->
      expect(subject.calculateEndPosition(['B'], [0,0])).to.deep.equal([-1,0])
    it 'subtracts 1 from Y on R', ->
      expect(subject.calculateEndPosition(['R'], [0,0])).to.deep.equal([0,-1])
    it 'can go in a loop', ->
      expect(subject.calculateEndPosition(['F','R','B','L'], [0,0])).to.deep.equal([0,0])
