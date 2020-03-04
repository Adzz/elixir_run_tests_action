# Elixir Test Github Action

This github action will run tests using the official Elixir 1.10 docker container. If the project is an umbrella app, it will `cd` into all of the apps and run all of the tests in each app, even if the tests in one of the apps fails. This means you will be able to see all of the test failures in one go, avoiding the need for multiple runs.

We:
  - Set MIX_ENV=test
  - mix deps.get
  - mix deps.compile --force
  - mix compile --force --warnings-as-errors
  - Run all the tests.

## Example usage

Add a `.github/workflows/main.yaml` file to the root of the project you want to include it in then inside that you can configure like so:

### On the open of a pull request

```yaml
on: [pull_request]

jobs:
  run_tests:
    runs-on: ubuntu-latest
    steps:
    # This is an action from github that checks out the code in the repo.
    - uses: actions/checkout@v2
    # Give it any name you like
    - name: "run dem tests"
      uses: Adzz/elixir_run_tests_action@v1.0.1
```
