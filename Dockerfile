FROM golang:alpine

COPY ./ /go/acra-go/

RUN apk --no-cache add git bash \
 && cd /go/acra-go \
 && bash build.sh

FROM alpine:latest

MAINTAINER Dmitry Karikh <the.dr.hax@gmail.com>

COPY run.sh /
COPY --from=0 /go/acra-go/bin/acra-go /bin/acra-go

RUN mkdir /data

WORKDIR /data
VOLUME /data
EXPOSE 80

ENTRYPOINT ["/run.sh"]
