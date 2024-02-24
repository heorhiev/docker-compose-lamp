#!/bin/sh

echo "Running project builder"

HOME_DIR=$PWD

git config --global --add safe.directory '*'

if [ ! -f "$PROJECT_FOLDER/README.md" ]; then
  echo "Clone main repo (branch $BASE_BRANCH)"
  rm -rf ${PROJECT_FOLDER} && mkdir -p ${PROJECT_FOLDER}
  git clone "http://$GIT_AUTH@$PROJECT_REPO" ${PROJECT_FOLDER}
elif [ $UPDATE_REPOS ]; then
  echo "Update main repo (branch $BASE_BRANCH)"
fi

cd ${PROJECT_FOLDER} && git checkout -f ${BASE_BRANCH} && git pull