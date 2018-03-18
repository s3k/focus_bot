from ruby:2.5

run mkdir /app
workdir /app
add . .

env RACK_ENV=production

run bundle

entrypoint ./start
