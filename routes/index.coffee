exports.index = (req, res) ->
  res.render 'index', { title: 'ChineseWhispers' }

exports.setup = (req, res) ->
  res.render 'setup', { title: 'ChineseWhispers' }
