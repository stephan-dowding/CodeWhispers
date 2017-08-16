exports.randomise = function(list) {
  list = list.slice(0);

  for (let i = 0; i < list.length - 1; ++i) {
    let j = random(i + 1, list.length);
    [list[j], list[i]] = [list[i], list[j]];
  }
  return list;
};

let random = function(min, max) {
  return min + Math.floor(Math.random() * (max - min));
};
