# Start from the latest golang base image
FROM golang:alpine AS build

LABEL maintainer="yantao.freedom@yahoo.com"

# Set the current working dir inside the container
WORKDIR /go/src/tech-challenge

# Copy go mod and sum files
COPY go.mod go.sum ./
# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Create user and group named with appuser 
ENV UID=1001
ENV GID=1001
RUN addgroup -g "${GID}" appuser && adduser --disabled-password --gecos "" --shell "/sbin/nologin" --no-create-home --uid "${UID}" --ingroup appuser appuser

# Copy the entire project to the working dir and build it
# This layer is rebuilt when a file changes in the project directory
COPY . . 
RUN CGO_ENABLED=0 go build -a -ldflags '-extldflags "-static"' -o /bin/tech-challenge .

# Build a small image 
FROM scratch
COPY --from=build /bin/tech-challenge /bin/tech-challenge
COPY --from=build /etc/passwd /etc/group /etc/
# Expose port 3000 to the outside world
EXPOSE 3000
# Use an unprivileged user.
USER appuser:appuser
# Run the executable
ENTRYPOINT ["/bin/tech-challenge"]
