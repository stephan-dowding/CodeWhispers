exports.challenge = function() {
  const start = Math.floor(Math.random() * 10);
  const distance = Math.floor(Math.random() * 10) + 1;
  return {
    question: {
      start: start,
      instructions: Array(distance + 1).join('F')
    },
    answer: {
      end: start + distance
    }
  };
};
