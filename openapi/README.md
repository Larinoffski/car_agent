# openapi/

`openapi.yaml` is the API contract and the source of truth: an API change starts here.

## Viewing

`make up` (ENV=local) starts Swagger UI at http://localhost:8081, reading `openapi.yaml` from this directory.

## Validation

Not configured yet: a linter for the spec and response validation in feature tests come with the test tooling.
