chai = require "chai"
randomiser = require "../../swapper/listRandomiser"

expect = chai.expect

describe 'listRandomiser', ->
  describe '#randomise()', ->
    it 'swaps elements in an array with count 2', ->
      expect(randomiser.randomise [1,2]).to.deep.equal([2,1])
