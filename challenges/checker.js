exports.check = function(answer, response) {
  return Object.keys(answer)
  .every((item) => answer[item] === response[item]);
};
