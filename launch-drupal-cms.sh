#!/usr/bin/env sh

###
# Launches Drupal CMS using DDEV.
#
# This requires that DDEV be installed and available in the PATH, and
# only works in Unix-like environments (Linux, macOS, or the Windows
# Subsystem for Linux). This will initialize a new DDEV project based
# on Drupal CMS, start the containers, install dependencies, and open
# Drupal's interactive installer in the browser.
###

# Abort this entire script if any one command fails.
set -e

# If we're running in a DDEV container, there's nothing to do.
if [ -n "$IS_DDEV_PROJECT" ]; then
  echo "Drupal CMS is already running. Run 'ddev launch' to open it in a browser."
  exit 0
fi

if ! command -v ddev >/dev/null; then
  echo "DDEV needs to be installed. Visit https://ddev.readthedocs.io/en/stable for instructions."
  exit 1
fi

PROJECT_ROOT=$(cd "$(dirname "$0")" && pwd -P)

# As a safeguard, don't continue without a sane value for PROJECT_ROOT.
if [ -z "$PROJECT_ROOT" ]; then
  echo "Fatal error: Could not detect the project root."
  exit 1
fi

# If needed, configure DDEV and build the code base.
if [ ! -d "$PROJECT_ROOT/.ddev" ]; then
  # Delete everything in the project root so that DDEV can spin up the
  # project cleanly.
  rm -r -f $PROJECT_ROOT/*

  ddev config --project-type=drupal11 --docroot=web
  ddev composer create drupal/cms --stability="RC"
fi

ddev launch
