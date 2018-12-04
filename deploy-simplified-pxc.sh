#!/usr/bin/env bash

DEPLOYMENT_NAME="${1}"

if [[ -z ${DEPLOYMENT_NAME} ]]; then
  echo "Please provide a deployment name as the first parameter"
  exit 1
fi

echo DEPLOYMENT_NAME="${DEPLOYMENT_NAME}"

WORKSPACE_FOLDER="${2}"

if [[ -z ${WORKSPACE_FOLDER} ]]; then
    WORKSPACE_FOLDER=/Users/pivotal/workspace
fi

echo WORKSPACE_FOLDER="${WORKSPACE_FOLDER}"

bosh deploy \
  --deployment=${DEPLOYMENT_NAME} \
  ${WORKSPACE_FOLDER}/cf-deployment/cf-deployment.yml \
  --ops-file=${WORKSPACE_FOLDER}/cf-deployment/operations/rename-network-and-deployment.yml \
  --ops-file=${WORKSPACE_FOLDER}/cf-deployment/operations/use-compiled-releases.yml \
  --ops-file=${WORKSPACE_FOLDER}/cf-deployment/operations/use-pxc.yml \
  --ops-file=${WORKSPACE_FOLDER}/cf-deployment/operations/backup-and-restore/enable-backup-restore.yml \
  --ops-file=${WORKSPACE_FOLDER}/uaa-deployment/operations/simplify-cf-deployment.yml \
  --ops-file=${WORKSPACE_FOLDER}/uaa-deployment/operations/use-local-uaa-release.yml \
  --var=local-uaa-release-path=${WORKSPACE_FOLDER}/uaa-release \
  --no-redact \
  --var=network_name=default \
  --var=deployment_name=${DEPLOYMENT_NAME} \
  --var=system_domain=${DEPLOYMENT_NAME}.cf-app.com

