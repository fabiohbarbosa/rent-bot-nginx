#!/usr/bin/env bash
set -e # ensure that this script will return a non-0 status code if any of rhe commands fail
set -o pipefail # ensure that this script will return a non-0 status code if any of rhe commands fail

SCRIPTS_PATH=.circleci/scripts

echo "Configure git to push tag and increase project version"
rm -rf ${HOME}/.gitconfig
git config --global push.default simple
git config --global user.name "CircleCI - ${GITHUB_USER}"
git config --global user.email ${GITHUB_USER}
git remote add circleci https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${GITHUB_REPONAME}.git

echo "Ensure there isn't changes in VERSION file"
git checkout VERSION

echo "Sync master changes"
git pull circleci master

echo "Save version in VERSION file"
bash ${SCRIPTS_PATH}/version.sh

echo "Commit changes"
VERSION=$(head -n 1 VERSION)
git add VERSION
git commit -m "[skip ci] prepare release ${GITHUB_REPONAME}-${VERSION}"

echo "Push changes"
git push circleci master --tags
