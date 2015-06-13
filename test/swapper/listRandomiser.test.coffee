randomiser = require "../../swapper/listRandomiser"

assert = require "assert"

describe 'listRandomiser', ->
  describe '#randomise()', ->
    it 'swaps elements in an array with count 2', ->
      result = randomiser.randomise [1,2]
      assert.equal result[0], 2
      assert.equal result[1], 1
