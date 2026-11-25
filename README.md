# car_agent

Short description of the project.

## Getting started

Prerequisites: Docker with Compose 2.24 or newer, `make`.

```sh
cp envs/secrets.env.example envs/secrets/local.env   # fill in local secrets
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

```sh
make lint                          # code style (Pint, check only) and PHPStan
make format                        # format the whole project with Pint
make format FILES="app/Models/User.php"
make phpstan ARGS="app/Models"     # PHPStan alone, with extra arguments
make psalm                         # second analyser, not part of lint
make hooks                         # once per clone: format and lint before every commit
make sync                          # after a PR is merged: update main, drop merged branches
```

Static analysis covers `app`, `database` and `routes`: PHPStan (with Larastan) at level 10 is required, Psalm with its Laravel plugin and taint analysis is advisory and never blocks a merge.

Tests use Pest and run inside the `app` container against a separate database, `car_agent_test`. It is created next to the main one when the Postgres volume is first initialised; `tests/TestCase.php` refuses to run against any database whose name does not end in `_test`.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

TBD
