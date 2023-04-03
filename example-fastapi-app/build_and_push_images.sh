#!/usr/bin/env bash
#
# Usage:
#   ./build_and_push_images.sh

set -euox pipefail

AWS_ACCOUNT_ID="$(aws sts get-caller-identity | jq -r '.Account')"
AWS_REGION="$(aws configure get region)"
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
DOCKERFILE_DIR_PATH="$(realpath "${0}" | xargs dirname)"
DOCKERFILE_PATH="${DOCKERFILE_DIR_PATH}/Dockerfile"
IMAGE_NAME="$(basename "${DOCKERFILE_DIR_PATH}")"
IMAGE_TAG='latest'

[[ -f "${DOCKERFILE_PATH}" ]]

aws ecr describe-repositories --repository-names "${IMAGE_NAME}" \
  || aws ecr create-repository --repository-name "${IMAGE_NAME}"
aws ecr get-login-password --region "${AWS_REGION}" \
  | docker login --username AWS --password-stdin \
    "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
docker image build \
  --tag "${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}" \
  --file "${DOCKERFILE_PATH}" "${DOCKERFILE_DIR_PATH}" \
  && docker image push "${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
