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

TBD

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

TBD
