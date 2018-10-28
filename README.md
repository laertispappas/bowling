# bowling

## Prerequisites

* [Docker Compose](https://docs.docker.com/compose/install/)

Navigate to root directory (`bowling`) and run:

* `docker-compose up --build` This will run a postgresql db and the api as docker containers

## Api

1. Create a game: `curl localhost:3000/api/v1/games -H "Content-Type: application/json" -d '{"users": [{"name": "LP"}]}'`
2. Get game details: `curl localhost:3000/api/v1/games/:GAME_ID` retrieved from step 1
3. Make a roll for a user: `curl localhost:3000/api/v1/games/:GAME_ID/players/:player_id/frames/:FRAME_ID/roll -H "Content-Type: application/json" -d '{"pins": 3}'` retrieved from step 1 || 2

## Run tests

* `docker-compose run web bundle exec rspec spec`
