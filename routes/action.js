import connection from './connection'
import branch from './branch'
import round from './round'

exports.nextRound = function(req, res) {
  branch.performSwap((branchMapping) =>
    round.increment()
    .then((number) =>
      res.status(200).json({
        round: number,
        mapping: branchMapping
      })
    )
    .catch((error) => res.status(500).send(error))
  );
};
