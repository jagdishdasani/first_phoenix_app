FROM elixir:1.6-slim

ADD / /app/

WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends wget gnupg ca-certificates
RUN wget -qO- https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get update && \
    apt-get install -y -q --no-install-recommends nodejs build-essential && \
    apt-get clean -qq && \
    apt-get autoremove

ENV MIX_ENV prod
ENV PORT=8080

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez
RUN mix deps.get
RUN npm install
RUN npm install -g brunch
RUN brunch build --production
RUN mix phx.digest
RUN mix compile