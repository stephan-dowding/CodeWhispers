import {expect} from "chai"

import subject from "../../challenges/challenge4"

import challengeUtils from "../../challenges/challengeUtils"

describe('challenge4', () => {
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
  it('marks the treasure as found when it should', () => {
    var a, challenge;
    challenge = subject.getChallenge(true);
    a = challenge.answer;
    expect(a.treasureFound).to.be["true"];
  });
  it('marks the treasure as not found when it should', () => {
    var a, challenge;
    challenge = subject.getChallenge(false);
    a = challenge.answer;
    expect(a.treasureFound).to.be["false"];
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
    if (a.treasureFound) {
      expect(route).to.contain.something.that.deep.equals([q.treasureX, q.treasureY]);
    } else {
      expect(route).not.to.contain.something.that.deep.equals([q.treasureX, q.treasureY]);
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
  it('places the pirate after treasure when both found', () => {
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
    expect(treasureIndex).to.be.lessThan(pirateIndex);
  });
  it('marks the treasure as stolen when both treasure and pirate found', () => {
    var a, challenge;
    challenge = subject.getChallenge(true, true);
    a = challenge.answer;
    expect(a.treasureStolen).to.be["true"];
  });
  it('marks the treasure as not stolen when found and pirate not found', () => {
    var a, challenge;
    challenge = subject.getChallenge(true, false);
    a = challenge.answer;
    expect(a.treasureStolen).to.be["false"];
  });
  describe('marks the treasure as not stolen if treasure not found', () => {
    it('pirate found', () => {
      var a, challenge;
      challenge = subject.getChallenge(false, true);
      a = challenge.answer;
      expect(a.treasureStolen).to.be["false"];
    });
    it('pirate not found', () => {
      var a, challenge;
      challenge = subject.getChallenge(false, false);
      a = challenge.answer;
      expect(a.treasureStolen).to.be["false"];
    });
  });
});
