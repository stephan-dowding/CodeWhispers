exports.challenge = function() {
  const number = Math.floor(Math.random() * 10);
  return {
    question: {
      start: number
    },
    answer: {
      end: number
    }
  };
};
