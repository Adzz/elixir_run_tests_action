# Elixir Test Github Action

This github action will run tests using the official Elixir 1.10 docker container. If the project is an umbrella app, it will `cd` into all of the apps and run all of the tests in each app, even if the tests in one of the apps fails. This means you will be able to see all of the test failures in one go, avoiding the need for multiple runs.

