# Elixir Test Github Action

This github action will run tests using the official Elixir 1.10 docker container. If the project is an umbrella app, it will `cd` into all of the apps and run all of the tests in each app, even if the tests in one of the apps fails. This means you will be able to see all of the test failures in one go, avoiding the need for multiple runs.

We:
  - Set MIX_ENV=test
  - mix deps.get
  - mix deps.compile --force
  - mix compile --force --warnings-as-errors
  - Run mix test.ci

## Adding the mix task

**NOTE** this action runs a mix task called `mix test.ci` so you need to add that alias in your mix.exs. This allows you to add flags to the test command, or setup the database etc.

```elixir
  defp aliases do
    [
      ...
      "test.ci": ["test --color --max-cases=10"],
      ...
    ]
end
```
In an umbrella you should define a command in each app, they can do different things if you wish.

You may also want to set the preferred CLI env for the task alias. When this action runs the mix env is automatically set and so everything is fine, but if you add a `mix test.ci` command and try to run that locally it will by default be in the :dev env, which is not what you want for test running. So you can either do this: `MIX_ENV=test mix test.ci` or set this in the `project` in the `mix.exs`

```elixir
def project do
  [
    ...
    preferred_cli_env: ["test.ci": :test],
    ...
  ]
end
```

## Example usage

### In a simple library (no database)

Add this to your `mix.exs`

```elixir
  defp aliases do
    [
      ...
      "test.ci": ["test --color --max-cases=10"],
      ...
    ]
end
```

Add a `.github/workflows/main.yaml` file to the root of the project you want to include it in then inside that you can configure like so:

#### On the open of a pull request

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
      uses: Adzz/elixir_run_tests_action@v2.0.0
```

#### On push

```yaml
on: [push]

jobs:
  run_tests:
    runs-on: ubuntu-latest
    steps:
    # This is an action from github that checks out the code in the repo.
    - uses: actions/checkout@v2
    # Give it any name you like
    - name: "run dem tests"
      uses: Adzz/elixir_run_tests_action@v2.0.0
```

### App with a database

Add this to the relevant `mix.exs`

```elixir
  defp aliases do
    [
      ...
      "test.ci": ["ecto.drop", "ecto.create --quiet", "ecto.migrate", "test"],
      ...
    ]
end
```

Or if you have a seeds file:

```elixir
  defp aliases do
    [
      ...
      "test.ci": ["ecto.drop", "ecto.create --quiet", "ecto.migrate", "run priv/repo/seeds.exs", "test"],
      ...
    ]
end
```
#### On the open of a pull request

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
      uses: Adzz/elixir_run_tests_action@v2.0.0
```

#### On push

```yaml
on: [push]

jobs:
  run_tests:
    runs-on: ubuntu-latest
    steps:
    # This is an action from github that checks out the code in the repo.
    - uses: actions/checkout@v2
    # Give it any name you like
    - name: "run dem tests"
      uses: Adzz/elixir_run_tests_action@v2.0.0
```



More info available in the [workflow docs](https://help.github.com/en/actions/configuring-and-managing-workflows/configuring-a-workflow)
