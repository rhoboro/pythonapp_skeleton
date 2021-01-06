BASE_IMAGE:=base
BASE_IMAGE_TAG:=python3.9-slim
IMAGE:=app
TARGET:=dev
TAG:=local
WORKDIR:=/usr/src
CMD:=
MARK:="not optional"

format: test_modules
	docker run --rm --name ${IMAGE} -w ${WORKDIR} -v $$(pwd):${WORKDIR} -e PYTHONPATH=test_modules ${IMAGE}/${TARGET}:${TAG} python3 -m black app
	docker run --rm --name ${IMAGE} -w ${WORKDIR} -v $$(pwd):${WORKDIR} -e PYTHONPATH=test_modules ${IMAGE}/${TARGET}:${TAG} python3 -m isort app

build: requirements.lock
	docker build --target ${TARGET} --build-arg BASE_IMAGE=${BASE_IMAGE} --build-arg BASE_IMAGE_TAG=${BASE_IMAGE_TAG} -t ${IMAGE}/${TARGET}:${TAG} .

build-dev:
	@make build TARGET=dev

build-prod:
	@make build TARGET=prod TAG=$$(git rev-parse HEAD)

build-baseimage:
	cd baseimage && docker build -t ${BASE_IMAGE}:${BASE_IMAGE_TAG} .

run:
	docker run -it --rm --name ${IMAGE} -w ${WORKDIR} -v $$(pwd):${WORKDIR} -e APP_CONFIG_FILE=base ${IMAGE}/${TARGET}:${TAG} ${CMD}

requirements.lock:
	docker run -it --rm  -w ${WORKDIR} -v $$(pwd):${WORKDIR} ${BASE_IMAGE}:${BASE_IMAGE_TAG} bash -c 'pip install -r requirements.txt && pip freeze > requirements.lock'

test_modules:
	docker run -it --rm -w ${WORKDIR} -v $$(pwd):${WORKDIR} ${BASE_IMAGE}:${BASE_IMAGE_TAG} bash -c 'pip install -t test_modules -r requirements_test.txt'

test: test_modules
	@make test-format
	@make test-pytest
	@make test-mypy

test-format:
	docker run --rm --name ${IMAGE} -w ${WORKDIR} -v $$(pwd):${WORKDIR} -e PYTHONPATH=test_modules ${IMAGE}/${TARGET}:${TAG} python3 -m black --check app
	docker run --rm --name ${IMAGE} -w ${WORKDIR} -v $$(pwd):${WORKDIR} -e PYTHONPATH=test_modules ${IMAGE}/${TARGET}:${TAG} python3 -m isort --check app

test-mypy:
	docker run --rm --name ${IMAGE} -w ${WORKDIR} -v $$(pwd):${WORKDIR} -e PYTHONPATH=test_modules ${IMAGE}/${TARGET}:${TAG} python3 -m mypy app

test-pytest:
	docker run --rm --name ${IMAGE} -w ${WORKDIR} -v $$(pwd):${WORKDIR} -e PYTHONPATH=test_modules ${IMAGE}/${TARGET}:${TAG} python3 -m pytest -m ${MARK}

test-all:
	@make test MARK='""'
