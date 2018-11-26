FROM golang:1.11.1 as build

ADD . /src

ENV GOOS=linux
ENV GOARCH=amd64
ENV CGO_ENABLED=0
RUN cd /src && go build -o play-golang -ldflags '-w -s' main.go

# ---

FROM alpine as stage

RUN apk add --no-cache ca-certificates tzdata

# ---

FROM scratch

COPY --from=stage /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=stage /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

WORKDIR /app

COPY --from=build /src/play-golang ./

ENTRYPOINT ["/app/play-golang"]
