import {expect} from "chai"
import branch from "../../routes/branch"

describe("route branch", () =>
  describe("#entangle", () =>
    it("combines arrays", () => {
      expect(branch.entangle(['a','b','c'],['1','2','3']))
      .to.deep.equal([
        {origin: 'a', destination: '1'},
        {origin: 'b', destination: '2'},
        {origin: 'c', destination: '3'}
      ])
    })
  )
)
