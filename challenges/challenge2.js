import challengeUtils from './challengeUtils'

exports.challenge = function() {
  const startX = Math.floor(Math.random() * 20) + 10;
  const startY = Math.floor(Math.random() * 20) + 10;
  const instructions = challengeUtils.getInstructions(Math.floor(Math.random() * 10) + 10);
  const endPosition = challengeUtils.calculateEndPosition(instructions, [startX, startY]);
  return {
    question: {
      startX: startX,
      startY: startY,
      instructions: instructions.join('')
    },
    answer: {
      endX: endPosition[0],
      endY: endPosition[1]
    }
  };
};
