import challengeUtils from './challengeUtils'

exports.challenge = function() {
  const shouldFindTreasure = Math.floor(Math.random() * 2) === 1;
  const shouldMeetPirate = Math.floor(Math.random() * 2) === 1;
  const shouldMeetSpy = Math.floor(Math.random() * 2) === 1;
  return exports.getChallenge(shouldFindTreasure, shouldMeetPirate, shouldMeetSpy);
};

exports.getChallenge = function(shouldFindTreasure, shouldMeetPirate, shouldMeetSpy) {
  const startX = Math.floor(Math.random() * 20) + 10;
  const startY = Math.floor(Math.random() * 20) + 10;
  const instructions = challengeUtils.getInstructions(Math.floor(Math.random() * 10) + 10);
  const treasureCoordinate = challengeUtils.calculateItemCoordinate(instructions, shouldFindTreasure, [startX, startY]);
  const midPosition = challengeUtils.calculateEndPosition(instructions, [startX, startY]);
  const furtherInstructions = challengeUtils.getInstructions(Math.floor(Math.random() * 10) + 10);
  const pirateCoordinate = challengeUtils.calculateItemCoordinate(furtherInstructions, shouldMeetPirate, midPosition);
  const endPosition = challengeUtils.calculateEndPosition(furtherInstructions, midPosition);
  const treasureIndex = challengeUtils.getFirstIndexOfCoordinate(treasureCoordinate, instructions, [startX, startY]);
  const preTreasure = instructions.slice(0, treasureIndex);
  const spyCoordinate = challengeUtils.calculateItemCoordinate(preTreasure, shouldMeetSpy, [startX, startY]);
  return {
    question: {
      startX: startX,
      startY: startY,
      treasureX: treasureCoordinate[0],
      treasureY: treasureCoordinate[1],
      pirateX: pirateCoordinate[0],
      pirateY: pirateCoordinate[1],
      spyX: spyCoordinate[0],
      spyY: spyCoordinate[1],
      instructions: instructions.concat(furtherInstructions).join('')
    },
    answer: {
      endX: endPosition[0],
      endY: endPosition[1],
      treasureFound: shouldFindTreasure,
      treasureStolen: shouldFindTreasure && (!shouldMeetPirate !== !shouldMeetSpy)
    }
  };
};
