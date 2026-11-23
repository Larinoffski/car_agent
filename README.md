# car_agent

Short description of the project.

## Getting started

Prerequisites: Docker with Compose 2.24 or newer, `make`.

```sh
mkdir -p ~/.config/car_agent
cp envs/secrets.env.example ~/.config/car_agent/local.env   # fill in local secrets
make build
make composer CMD=install
make up
```

Environments and secrets: [envs/README.md](envs/README.md). Architecture: [docs/architecture.md](docs/architecture.md). `make help` lists all targets.

## Project structure

TBD

## Development

```sh
make test                          # all tests; the stack must be up
make test ARGS="--filter=Health"   # tests matching a name
```

Tests use Pest and run inside the `app` container against a separate database, `car_agent_test`. It is created next to the main one when the Postgres volume is first initialised; `tests/TestCase.php` refuses to run against any database whose name does not end in `_test`.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

TBD
