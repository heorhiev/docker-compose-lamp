#!/bin/sh

echo "Running project builder"

HOME_DIR=$PWD

rm -r ./project

git config --global --add safe.directory '*'

rm -rfd ./project
git clone -b ${BASE_BRANCH} "http://$GITLAB_AUTH@$PROJECT_REPO" ./project

MODULES="$(cat ./project/common/modules.txt)"
MODULES="${MODULES//$'\n'/ }"


if [ ! -f "$PROJECT_FOLDER/README.md" ]; then
  echo "Clone main repo (branch $BASE_BRANCH)"
  rm -rf ${PROJECT_FOLDER} && mkdir -p ${PROJECT_FOLDER}
  git clone "http://$GITLAB_AUTH@gitlab.sofona.com:1500/sofonateam/pelliron/crm.git" ${PROJECT_FOLDER}
elif [ $UPDATE_REPOS ]; then
  echo "Update main repo (branch $BASE_BRANCH)"
fi
cd ${PROJECT_FOLDER} && git checkout -f ${BASE_BRANCH} && git pull


echo "install modules"
for i in ${MODULES}
do
  MODULE_NAME=$(echo "$i" | awk -F'/' '{print $NF}')

  if [[ "$MODULE_NAME" == "keyPaymentsSystems" ]]; then
    MODULE_NAME="keyPaymentSystems"
  fi

  if [ ! -d "$PROJECT_FOLDER/crm/common/modules/$MODULE_NAME" ]; then
    echo "Clone module $MODULE_NAME"
    git clone "http://$GITLAB_AUTH@gitlab.sofona.com:1500/sofonateam/$i.git" ${PROJECT_FOLDER}/crm/common/modules/${MODULE_NAME}
    chmod 0755 ${PROJECT_FOLDER}/crm/common/modules/${MODULE_NAME}
  else
    echo "Update module $MODULE_NAME"
  fi
  cd "$PROJECT_FOLDER/crm/common/modules/$MODULE_NAME" && git pull
done


echo "check template"

TEMPLATE_PATH="$PROJECT_FOLDER/crm/common/templates/$TEMPLATE_NAME"
if [ -n "$TEMPLATE_NAME" ] && [ ! -d ${TEMPLATE_PATH} ]; then
  echo "Clone template repo (branch $BASE_BRANCH)"
  git clone "http://$GITLAB_AUTH@$TEMPLATE_REPO" ${TEMPLATE_PATH}
elif [ -n "$TEMPLATE_NAME" ]; then
  echo "Update template repo (branch $BASE_BRANCH)"
fi
cd ${TEMPLATE_PATH} && git checkout -f ${BASE_BRANCH} && git pull


echo "install config"
cd ${HOME_DIR}

if [ ! -f "$PROJECT_FOLDER/crm/common/config/main-local.php" ]; then
  for FOLDER in frontend backend common
  do
    echo "cp $FOLDER config"

    cp ./project/${FOLDER}/config/main-local.php ${PROJECT_FOLDER}/crm/${FOLDER}/config/main-local.php
    cp ./project/${FOLDER}/config/params-local.php ${PROJECT_FOLDER}/crm/${FOLDER}/config/params-local.php

    chmod 0755 ${PROJECT_FOLDER}/crm/${FOLDER}/config/main-local.php
    chmod 0755 ${PROJECT_FOLDER}/crm/${FOLDER}/config/params-local.php
  done

  cp -r ./project/common/config/modules/ ${PROJECT_FOLDER}/crm/common/config/
  chmod 0755 ${PROJECT_FOLDER}/crm/common/config/modules

  echo "config cp end"

elif [ $UPDATE_REPOS ]; then
  echo "config exists!"
fi


echo "baseInstaller end"

#  chown 1000:1000 ${PROJECT_FOLDER}/crm/common/modules/${i}/.git/FETCH_HEAD ${PROJECT_FOLDER}/crm/common/modules/${i}/.git/ORIG_HEAD

