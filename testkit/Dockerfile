FROM golang as builder
ARG GITHUB_TOKEN
WORKDIR /go/src/github.com/sunfmin/testkit
COPY . .
RUN set -x && \
    go get -d -v ./testkit/... && \
    GOOS=linux CGO_ENABLED=0 GOARCH=amd64 go build -o /app/entry ./testkit/

FROM alpine
COPY --from=builder /app/entry  /bin/testkit
CMD /bin/testkit
