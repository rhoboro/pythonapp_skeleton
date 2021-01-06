ARG BASE_IMAGE
ARG BASE_IMAGE_TAG
FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG} AS dev
WORKDIR /app

COPY ./requirements.lock /app
RUN pip install -r requirements.lock

EXPOSE 80

CMD ["python3", "-c", "from app import main; main.main()"]

FROM dev AS prod
COPY ./app /app/app
