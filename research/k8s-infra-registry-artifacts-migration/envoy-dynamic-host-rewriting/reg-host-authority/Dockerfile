# Envoy
# Prepare a container image for the reg-host-authority

FROM golang:1.17.0-alpine3.14 AS build
WORKDIR /app
COPY main.go /app/
COPY go.* *.go /app/
ARG GOARCH=""
RUN CGO_ENABLED=0 GOOS=linux GOARCH="$GOARCH" go build \
  -a \
  -installsuffix cgo \
  -ldflags "-extldflags '-static' -s -w" \
  -o bin/reg-host-authority \
  main.go

FROM alpine:3.14 AS extras
RUN apk add --no-cache tzdata ca-certificates
RUN adduser -D user

FROM scratch AS final
WORKDIR /app
ENV PATH=/app \
  APP_DIST_FOLDER=./dist
COPY --from=build /app/bin/reg-host-authority /app/bin/reg-host-authority
COPY --from=extras /etc/passwd /etc/passwd
COPY --from=extras /etc/group /etc/group
COPY --from=extras /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=extras /etc/ssl /etc/ssl
EXPOSE 8080
USER user
ENTRYPOINT ["/app/bin/reg-host-authority"]
