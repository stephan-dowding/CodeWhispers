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

  describe '#calculateItemCoordinate', ->
    context 'find item', ->
      it 'positions the item on the spot when no instructions', ->
        item = subject.calculateItemCoordinate([], true, [0, 0])
        expect(item).to.deep.equal([0,0])

      context 'positions the item on the route', ->
        it 'F route', ->
          [tX, tY] = subject.calculateItemCoordinate(['F','F','F','F','F'], true, [0, 0])
          expect(tX).to.be.within(0,5)
          expect(tY).to.equal(0)
        it 'B route', ->
          [tX, tY] = subject.calculateItemCoordinate(['B','B','B','B','B'], true, [0, 0])
          expect(tX).to.be.within(-5,0)
          expect(tY).to.equal(0)
        it 'L route', ->
          [tX, tY] = subject.calculateItemCoordinate(['L','L','L','L','L'], true, [0, 0])
          expect(tX).to.equal(0)
          expect(tY).to.be.within(0,5)
        it 'R route', ->
          [tX, tY] = subject.calculateItemCoordinate(['R','R','R','R','R'], true, [0, 0])
          expect(tX).to.equal(0)
          expect(tY).to.be.within(-5,0)
        it 'loop route', ->
          [tX, tY] = subject.calculateItemCoordinate(['F','L','B','R'], true, [0, 0])
          expect(tX).to.be.within(0,1)
          expect(tY).to.be.within(0,1)

    context 'item not found', ->
       it 'loop route', ->
         item = subject.calculateItemCoordinate(['F','L','B','R'], false, [0, 0])
         expect([[0,0],[1,0],[1,1],[0,1]]).not.to.contain.something.that.deep.equals(item)
