import challengeUtils from './challengeUtils'

exports.challenge = function() {
  const shouldFindTreasure = Math.floor(Math.random() * 2) === 1;
  return exports.getChallenge(shouldFindTreasure);
};

exports.getChallenge = function(shouldFindTreasure) {
  const startX = Math.floor(Math.random() * 20) + 10;
  const startY = Math.floor(Math.random() * 20) + 10;
  const instructions = challengeUtils.getInstructions(Math.floor(Math.random() * 10) + 10);
  const endPosition = challengeUtils.calculateEndPosition(instructions, [startX, startY]);
  const treasureCoordinate = challengeUtils.calculateItemCoordinate(instructions, shouldFindTreasure, [startX, startY]);
  return {
    question: {
      startX: startX,
      startY: startY,
      treasureX: treasureCoordinate[0],
      treasureY: treasureCoordinate[1],
      instructions: instructions.join('')
    },
    answer: {
      endX: endPosition[0],
      endY: endPosition[1],
      treasureFound: shouldFindTreasure
    }
  };
};
