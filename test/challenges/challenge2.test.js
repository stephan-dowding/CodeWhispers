import {expect} from "chai"

import subject from "../../challenges/challenge2"

import challengeUtils from "../../challenges/challengeUtils"

describe('challenge2', () => {
  it('returns a string of FBLR for instructions', () => {
    let challenge = subject.challenge();
    expect(challenge.question.instructions.length).to.be.above(0);
    Array.from(challenge.question.instructions).forEach((char) =>
      expect(['F', 'B', 'L', 'R']).to.include(char)
    );
  });
  it('provides startX and startY as numbers', () => {
    let challenge = subject.challenge();
    expect(challenge.question.startX).to.be.a('number');
    expect(challenge.question.startY).to.be.a('number');
  });
  it('provides correct endX and endY', () => {
    let challenge = subject.challenge();
    let q = challenge.question;
    let a = challenge.answer;
    let instructions = q.instructions.split('');
    let ref = challengeUtils.calculateEndPosition(instructions, [q.startX, q.startY]), expectedEndX = ref[0], expectedEndY = ref[1];
    expect(a.endX).to.equal(expectedEndX);
    expect(a.endY).to.equal(expectedEndY);
  });
});
