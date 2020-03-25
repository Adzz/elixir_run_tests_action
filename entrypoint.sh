#!/bin/sh -l

# Github actions blow up on any command that exits non-zero. This is fine, but we
# want to run all tests in all apps. If we just run mix test or do a for loop
# into each app, we bail out of the first app we see a failure on, which may
# hide other failures down the line. That's a massive PITA if you have to
# keep rebuilding because of unseen errors following a CI fail.

# This script ensures all tests run, regardless of how many failures there are
# in different apps.

# Get dem deps first
mix deps.get
MIX_ENV=test mix deps.compile --force

# Compile everything, erroring on warnings to save some work.
MIX_ENV=test mix compile --force --warnings-as-errors

# Check if we are an umbrella app.
if [ -d "apps" ]; then
  GREAT_SUCCESS=0

  for app in $(ls apps)
  do
    echo ""
    echo "=> Running tests for: $app"
    cd apps/$app
    mix test.ci
    SUCCESS=$?

    if [ $SUCCESS != 0 ]
    then
      GREAT_SUCCESS=$SUCCESS
    fi
    cd ../../
  done
else
  mix test.ci
fi

exit $GREAT_SUCCESS
