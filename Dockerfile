FROM elixir:1.13.4-alpine as dev

RUN apk --update --no-cache add bash

WORKDIR /app

# install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

# set build ENV
ENV MIX_ENV=dev

# install mix dependencies
COPY mix.exs mix.lock .formatter.exs ./

RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# run server
CMD mix ecto.create && mix run --no-halt
