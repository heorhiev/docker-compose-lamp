FROM alpine/git

ARG PROJECT_FOLDER=/app/base
ARG GIT_AUTH
ARG PROJECT_REPO
ARG BASE_BRANCH

ENV PROJECT_FOLDER=$PROJECT_FOLDER
ENV GIT_AUTH=$GIT_AUTH
ENV PROJECT_REPO=$PROJECT_REPO
ENV BASE_BRANCH=$BASE_BRANCH


RUN git config --global --add safe.directory ${PROJECT_FOLDER}

COPY ./bin/baseInstaller/repo.sh /srv/repo.sh

RUN chmod +x /srv/repo.sh

ENTRYPOINT /srv/repo.sh
