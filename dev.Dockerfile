
FROM golang:1.11

# if left blank app will run with dev settings
ARG APP_ENV
ENV APP_ENV $APP_ENV

# Setting the working directory of the application
WORKDIR /go/src/play-go-1.11

# Adding all the source files of the application
COPY . /go/src/play-go-1.11

# Get all the dependency packages
RUN GO111MODULE=on go mod vendor

# Use fresh for code reloading via docker-compose volume sharing with local machine
RUN go get -u github.com/acoshift/goreload
CMD [ "goreload", "-x", "vendor", "--all" ]

EXPOSE 8880