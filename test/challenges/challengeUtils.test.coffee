chai = require "chai"
subject = require "../../challenges/challengeUtils"
chai.use(require('chai-things'));

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

  describe '#calculateTreasureCoordinate', ->
    context 'find treasure', ->
      it 'positions the treasure on the spot when no instructions', ->
        treasure = subject.calculateTreasureCoordinate([], true, [0, 0])
        expect(treasure).to.deep.equal([0,0])

      context 'positions the treasure on the route', ->
        it 'F route', ->
          [tX, tY] = subject.calculateTreasureCoordinate(['F','F','F','F','F'], true, [0, 0])
          expect(tX).to.be.within(0,5)
          expect(tY).to.equal(0)
        it 'B route', ->
          [tX, tY] = subject.calculateTreasureCoordinate(['B','B','B','B','B'], true, [0, 0])
          expect(tX).to.be.within(-5,0)
          expect(tY).to.equal(0)
        it 'L route', ->
          [tX, tY] = subject.calculateTreasureCoordinate(['L','L','L','L','L'], true, [0, 0])
          expect(tX).to.equal(0)
          expect(tY).to.be.within(0,5)
        it 'R route', ->
          [tX, tY] = subject.calculateTreasureCoordinate(['R','R','R','R','R'], true, [0, 0])
          expect(tX).to.equal(0)
          expect(tY).to.be.within(-5,0)
        it 'loop route', ->
          [tX, tY] = subject.calculateTreasureCoordinate(['F','L','B','R'], true, [0, 0])
          expect(tX).to.be.within(0,1)
          expect(tY).to.be.within(0,1)

    context 'treasure not found', ->
       it 'loop route', ->
         treasure = subject.calculateTreasureCoordinate(['F','L','B','R'], false, [0, 0])
         expect([[0,0],[1,0],[1,1],[0,1]]).not.to.contain.something.that.deep.equals(treasure)
