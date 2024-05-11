FROM golang:1.20.12-bookworm
# Set environment variables
ENV CA_CERT_PATH $CA_CERT_PATH
ENV TLS_KEY_PATH $TLS_KEY_PATH
ENV TESLA_PRIVATE_KEY_PATH $TESLA_PRIVATE_KEY_PATH
ENV REPO_URL https://github.com/RonnyWinkler/teslamotors-vehicle-command.git
RUN mkdir /TeslaProxy
WORKDIR /vehicle-command
# Run as root user
USER root
# Clone the repository
RUN git clone ${REPO_URL} .
# Install dependencies, build and install the project
RUN go get ./...
RUN go build ./...
RUN go install ./...
# Set the entrypoint and command
ENTRYPOINT ["/bin/bash", "-l", "-c"]
CMD ["/go/bin/tesla-http-proxy -tls-key $TLS_KEY_PATH -cert $CA_CERT_PATH -key-file $TESLA_PRIVATE_KEY_PATH -port 8080 -host 0.0.0.0 -verbose"]
#ENTRYPOINT ["tail"]
#CMD ["-f","/dev/null"]

