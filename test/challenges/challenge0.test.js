import {expect} from "chai"

import subject from "../../challenges/challenge0"

describe('challenge0', () => {
  it('returns same start and end number', () => {
    var challenge;
    challenge = subject.challenge();
    expect(challenge.question.start).to.equal(challenge.answer.end);
  });
});
