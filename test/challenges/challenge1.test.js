import {expect} from "chai"

import subject from "../../challenges/challenge1"

describe('challenge1', () => {
  it('returns a string of F for instructions', () => {
    var challenge;
    challenge = subject.challenge();
    expect(challenge.question.instructions.length).to.be.above(0);
    Array.from(challenge.question.instructions).forEach((char) =>
      expect(char).to.equal('F')
    );
  });
  it('end differs from start by length of instructions', () => {
    var a, challenge, q;
    challenge = subject.challenge();
    q = challenge.question;
    a = challenge.answer;
    expect(q.start + q.instructions.length).to.equal(a.end);
  });
});
