# CodeWhispers

CodeWhispers is a fun coding exercise where participants complete rounds of coding challenges. The twist is: after each round, the code created will be moved to another participant, so you have to keep building up functionality on someone else's code. The questions are: to refactor or not refactor?, to test or not to test?

CodeWhispers consists of a server which manages participants, rounds, swap code repos and validate the answers.

## Usage
### Prerequisites

- Docker and Docker Compose (to run locally)
- AWS Account and Terraform (to deploy to cloud)

### Running locally

```bash
$ cd docker
$ PUBLIC_HOSTNAME="localhost:8888" docker-compose up --build
```

### Deploy on AWS
(after PR #21 is merged)

```bash
$ cd deployment
$ terraform init
$ terraform apply 
```

### Endpoints

- `/dashboard`: Shows the instructions for the current round and a status across all participants
- `/control-panel`: For facilitators to advance everyone to the next round. Updates the instructions and swaps code between participants

### How to run a CodeWhispers workshop

- Assemble a group of people, each of them (or each pair), with a machine to work on
- Have the dashboard up on a big screen or projector to keep track
- Direct participants towards the dashboard URL and have them follow the instructions to set up their machine
- Once everyone has completed a round (as indicated by the green ticks on the dashboard), use the control-panel to advance to the next round
- Have all participants use the `./reconnect.sh` script to get a new codebase to work on for the next round

## Development

### Prerequisites

- Node, NPM
- MongoDB

### Set Up

```
$ npm install
$ npm test
```

### Start MongoDB

```
$ docker run -d -p 27017:27017 mongo
```

### Run Dev Server

```
$ npm start
```
