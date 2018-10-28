# bowling

## Prerequisites

* [Docker Compose](https://docs.docker.com/compose/install/)

Navigate to root directory (`bowling`) and run:

* `docker-compose up --build` This will run a postgresql db and the api as docker containers

## Api

1. Create a game: `curl localhost:3000/api/v1/games -H "Content-Type: application/json" -d '{"users": [{"name": "LP"}]}'`
2. Get game details: `curl localhost:3000/api/v1/games/:GAME_ID` retrieved from step 1
3. Make a roll for a user: `curl localhost:3000/api/v1/games/:GAME_ID/players/:player_id/frames/:FRAME_ID/roll -H "Content-Type: application/json" -d '{"pins": 3}'`. Game id, current player turn and current frame id are retrieved from step 1 or 2.

## Caching 

Api uses http caching for `/api/v1/games/:id endpoint`. 
Usage:

1. Make the first request for a game: `curl -i http://localhost:3000/api/v1/games/3`. HTTP status: 200
2. Get `ETag` value from response headers and pass it to the next requests: `curl -i http://localhost:3000/api/v1/games/3 -H 'If-None-Match: W/"ebfe4df560297a5dcc1f7800ca5ce851"'`. HTTP status: 304
3. When a a game is updated (a new roll takes place) the next GET request should respond with the updated JSON payload.



## Run tests

* `docker-compose run web bundle exec rspec spec`
