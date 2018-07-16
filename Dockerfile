FROM golang:latest AS build

RUN go get github.com/fatih/color \
    && go get github.com/google/go-jsonnet \
    && cd /go/src/github.com/google/go-jsonnet/jsonnet \
    && go build

RUN go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb
RUN go get github.com/brancz/gojsontoyaml

FROM alpine:latest

RUN apk add libc6-compat git

COPY --from=build /go/src/github.com/google/go-jsonnet/jsonnet/jsonnet /usr/local/bin
COPY --from=build /go/bin/jb /usr/local/bin
COPY --from=build /go/bin/gojsontoyaml /usr/local/bin

ENTRYPOINT [ "/usr/local/bin/jsonnet" ]