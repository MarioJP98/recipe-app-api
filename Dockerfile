FROM python:3.9-alpine3.13
LABEL maintainer="Mario Jimenez"

# This is to avoid buffering the outputs and prints directly to the terminal
ENV PYTHONUNBUFFERED 1

# COPY our local requirements file to the container use it to install the dependencies
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./scripts /scripts
# Directory that contains django project
COPY ./app /app
# Default directory when the container starts
WORKDIR /app
# Expose port 8000 to access the django development server
EXPOSE 8000


ARG DEV=false
# Create an environment to avoid conflicts
# upgrade pip and install dependencies
# remove the requirements file
# create a user (django-user) to run the application
# it's not recomended to use ROOT user
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client jpeg-dev && \
    apk add --update --no-cache --virtual .tmp-build-deps \
    build-base postgresql-dev musl-dev zlib zlib-dev linux-headers && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
    then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
    --disabled-password \
    --no-create-home \
    django-user && \
    mkdir -p /vol/web/media && \
    mkdir -p /vol/web/static && \
    chown -R django-user:django-user /vol && \
    chmod -R 755 /vol && \
    chmod -R +x /scripts

# to run commands directly from the env
ENV PATH="/scripts:/py/bin:$PATH"

# switch to the django-user
USER django-user

CMD ["run.sh"]
