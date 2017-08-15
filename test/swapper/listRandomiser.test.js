import {expect} from "chai"
import randomiser from "../../swapper/listRandomiser"

describe('listRandomiser', () =>
  describe('#randomise()', () =>
    it('swaps elements in an array with count 2', () =>
      expect(randomiser.randomise([1, 2])).to.deep.equal([2, 1])
    )
  )
)
