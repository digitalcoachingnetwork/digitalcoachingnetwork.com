> Digital Coaching Network official website

## Development
Use npm scripts and gulp

```sh
$ npm install       # install dependencies
$ gulp              # build and watch
$ npm run nodemon   # start nodemon
$ gulp open         # open localhost with correct port
```

## Deploy

```sh
# see .env for more information
heroku config:set SENDGRID_API_KEY=... TRELLO_API_KEY=... TRELLO_USER_TOKEN=...
```

## Trello API Documentation and Examples
https://github.com/GraemeF/trello/blob/master/main.js

```
https://api.trello.com/1/boards/hTTHCChJ?key=TRELLO_API_KEY&token=TRELLO_USER_TOKEN
https://api.trello.com/1/boards/i7iH6Dv5?lists=open&key=TRELLO_API_KEY&token=TRELLO_USER_TOKEN
```
