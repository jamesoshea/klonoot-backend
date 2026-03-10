# Klonoot backend

## Acknowledgements

This backend was derived largely from the work by recmo, here: https://github.com/recmo/PostgrestSkeleton

The routing engine is Brouter: https://brouter.de/brouter/index.html

## Motivation

This is mainly an experiment to see how little code I can write, to get a simple, but functional backend for [Klonoot](https://klonoot.org). Having created a backend in Supabase, I wanted to learn more about Postgres' capabilities, and also have more knowledge and control over my own infrastructure, instead of relying on cloud services for everything.

It's also fun to revive useful old projects.

In the future, I may implement routing in postgres itself, using [PostGIS](https://postgis.net/) and [pgRouting](https://github.com/pgrouting).

## Stack

- [Let’s Encrypt](https://letsencrypt.org/) as certificate authority
- [Nginx](http://nginx.org/) as web server
- [PostgREST](http://postgrest.com/) as API server
- [PostgreSQL](http://www.postgresql.org/) as database engine
- [Docker](https://www.docker.com/) to containerize
- [Docker compose](https://docs.docker.com/compose/) for orchestrating containers

## Running locally

Populate the `.env` file to match the `.env.example` file. Pick a high-entropy string for the `JWT_SECRET` (minimum 32 characters).

Allow postgres read-write access to the `data` dir (only necessary on Linux, not macOS. No idea about Windows):

`sudo setfacl -m u:$(id -u):rw -R ./data/`

Finally, build the postgres image with the `pg-jwt` extension, and run the containers:

`docker compose build`

`docker compose up`
