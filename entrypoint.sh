#!/bin/sh

# Start GitLab runner in background
/usr/bin/dumb-init /entrypoint run --user=gitlab-runner --working-directory=/home/gitlab-runner &

# Start Spring Boot application
java -jar /app/app.jar