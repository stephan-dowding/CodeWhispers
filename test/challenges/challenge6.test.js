import {expect} from "chai"

import subject from "../../challenges/challenge6"

import challengeUtils from "../../challenges/challengeUtils"


describe('challenge6', () => {
  it('returns a string of FBLR for instructions', () => {
    var challenge;
    challenge = subject.challenge();
    expect(challenge.question.instructions.length).to.be.above(0);
    Array.from(challenge.question.instructions).forEach((char) =>
      expect(['F', 'B', 'L', 'R']).to.include(char)
    );
  });
  it('provides startX and startY as numbers', () => {
    var challenge;
    challenge = subject.challenge();
    expect(challenge.question.startX).to.be.a('number');
    expect(challenge.question.startY).to.be.a('number');
  });
  it('provides treasureX and treasureY as numbers', () => {
    var challenge;
    challenge = subject.challenge();
    expect(challenge.question.treasureX).to.be.a('number');
    expect(challenge.question.treasureY).to.be.a('number');
  });
  it('provides correct endX and endY', () => {
    var a, challenge, expectedEndX, expectedEndY, instructions, q, ref;
    challenge = subject.challenge();
    q = challenge.question;
    a = challenge.answer;
    instructions = q.instructions.split('');
    ref = challengeUtils.calculateEndPosition(instructions, [q.startX, q.startY]), expectedEndX = ref[0], expectedEndY = ref[1];
    expect(a.endX).to.equal(expectedEndX);
    expect(a.endY).to.equal(expectedEndY);
  });
  it('places the treasure on the route when found', () => {
    var challenge, instructions, q, route;
    challenge = subject.getChallenge(true);
    q = challenge.question;
    instructions = q.instructions.split('');
    route = challengeUtils.calculatePath(instructions, [q.startX, q.startY]);
    expect(route).to.contain.something.that.deep.equals([q.treasureX, q.treasureY]);
  });
  it('places the treasure off the route when not found', () => {
    var challenge, instructions, q, route;
    challenge = subject.getChallenge(false);
    q = challenge.question;
    instructions = q.instructions.split('');
    route = challengeUtils.calculatePath(instructions, [q.startX, q.startY]);
    expect(route).not.to.contain.something.that.deep.equals([q.treasureX, q.treasureY]);
  });
  it('places the treasure on the route dependent on random selection', () => {
    var a, challenge, instructions, q, route;
    challenge = subject.challenge();
    q = challenge.question;
    a = challenge.answer;
    instructions = q.instructions.split('');
    route = challengeUtils.calculatePath(instructions, [q.startX, q.startY]);
    if (a.treasureOwner === 'no-one') {
      expect(route).not.to.contain.something.that.deep.equals([q.treasureX, q.treasureY]);
    } else {
      expect(route).to.contain.something.that.deep.equals([q.treasureX, q.treasureY]);
    }
  });
  it('places the pirate on the route when met', () => {
    var challenge, instructions, q, route;
    challenge = subject.getChallenge(false, true);
    q = challenge.question;
    instructions = q.instructions.split('');
    route = challengeUtils.calculatePath(instructions, [q.startX, q.startY]);
    expect(route).to.contain.something.that.deep.equals([q.pirateX, q.pirateY]);
  });
  it('places the pirate off the route when not met', () => {
    var challenge, instructions, q, route;
    challenge = subject.getChallenge(false, false);
    q = challenge.question;
    instructions = q.instructions.split('');
    route = challengeUtils.calculatePath(instructions, [q.startX, q.startY]);
    expect(route).not.to.contain.something.that.deep.equals([q.pirateX, q.pirateY]);
  });
  it('places the spy on the route when met', () => {
    var challenge, instructions, q, route;
    challenge = subject.getChallenge(false, false, true);
    q = challenge.question;
    instructions = q.instructions.split('');
    route = challengeUtils.calculatePath(instructions, [q.startX, q.startY]);
    expect(route).to.contain.something.that.deep.equals([q.spyX, q.spyY]);
  });
  it('places the spy off the route when not met', () => {
    var challenge, instructions, q, route;
    challenge = subject.getChallenge(false, false, false);
    q = challenge.question;
    instructions = q.instructions.split('');
    route = challengeUtils.calculatePath(instructions, [q.startX, q.startY]);
    expect(route).not.to.contain.something.that.deep.equals([q.spyX, q.spyY]);
  });
  it('places the pirate on after after treasure when both found', () => {
    var challenge, instructions, pirateIndex, q, route, treasureIndex;
    challenge = subject.getChallenge(true, true);
    q = challenge.question;
    instructions = q.instructions.split('');
    route = challengeUtils.calculatePath(instructions, [q.startX, q.startY]);
    treasureIndex = challengeUtils.getFirstIndexOfCoordinate([q.treasureX, q.treasureY], instructions, [q.startX, q.startY]);
    pirateIndex = route.reduce((itemAt, pos, index) => {
      if (pos[0] === q.pirateX && pos[1] === q.pirateY) {
        itemAt = index;
      }
      return itemAt;
    }, void 0);
    expect(pirateIndex).to.be.least(treasureIndex);
  });

  it('places the spy on or before treasure when both found', () => {
    var challenge, instructions, q, spyIndex, treasureIndex;
    challenge = subject.getChallenge(true, false, true);
    q = challenge.question;
    instructions = q.instructions.split('');
    treasureIndex = challengeUtils.getFirstIndexOfCoordinate([q.treasureX, q.treasureY], instructions, [q.startX, q.startY]);
    spyIndex = challengeUtils.getFirstIndexOfCoordinate([q.spyX, q.spyY], instructions, [q.startX, q.startY]);
    expect(spyIndex).to.be.most(treasureIndex);
  });

  it('marks the treasure owner as pirate when both treasure and pirate found', () => {
    var a, challenge;
    challenge = subject.getChallenge(true, true, false);
    a = challenge.answer;
    expect(a.treasureOwner).to.equal('pirate');
  });

  it('marks the treasure owner as spy when both treasure and spy found', () => {
    var a, challenge;
    challenge = subject.getChallenge(true, false, true);
    a = challenge.answer;
    expect(a.treasureOwner).to.equal('spy');
  });

  it('marks the treasure owner as me when treasure, pirate and spy found', () => {
    var a, challenge;
    challenge = subject.getChallenge(true, true, true);
    a = challenge.answer;
    expect(a.treasureOwner).to.equal('me');
  });
  it('marks the treasure owner as me when treasure found but pirate and spy are not', () => {
    var a, challenge;
    challenge = subject.getChallenge(true, false, false);
    a = challenge.answer;
    expect(a.treasureOwner).to.equal('me');
  });
  describe('marks the treasure owner as no-one if treasure not found', () => {
    it('found pirate', () => {
      var a, challenge;
      challenge = subject.getChallenge(false, true, false);
      a = challenge.answer;
      expect(a.treasureOwner).to.equal('no-one');
    });
    it('found spy', () => {
      var a, challenge;
      challenge = subject.getChallenge(false, false, true);
      a = challenge.answer;
      expect(a.treasureOwner).to.equal('no-one');
    });
    it('found pirate and spy', () => {
      var a, challenge;
      challenge = subject.getChallenge(false, true, true);
      a = challenge.answer;
      expect(a.treasureOwner).to.equal('no-one');
    });
    it('all lonely', () => {
      var a, challenge;
      challenge = subject.getChallenge(false, false, false);
      a = challenge.answer;
      expect(a.treasureOwner).to.equal('no-one');
    });
  });
});
