# DEVELOPER DOCUMENTATION

## Purpose

This document describes how the Inception infrastructure is built, how it works internally, and the design decisions behind each component.

It is intended for developers, maintainers, and evaluators who want to understand the architecture and technical choices of the project.

---

## Development Environment

### Host System

- Linux virtual machine
- Docker Engine
- Docker Compose v2
- Make

The virtual machine acts as the Docker host. All containers run inside this VM.

---

## Project Structure

```text
inception/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
└── srcs/
    ├── docker-compose.yml
    ├── .env
    └── requirements/
        ├── mariadb/
        ├── wordpress/
        ├── nginx/
        └── bonus/
            ├── adminer/
            ├── redis/
            ├── static_site/
            ├── ftp/
            └── monitoring/
````

Each service has:

* Its own directory
* Its own Dockerfile
* Its own configuration files

This ensures clear separation of concerns.

---

## Build and Launch Process

### Makefile

The Makefile is the entry point for managing the infrastructure.

Key targets:

* `make`
  Builds images and starts containers
* `make down`
  Stops containers without deleting data
* `make clean`
  Removes containers and volumes
* `make fclean`
  Full cleanup including host data directories

The Makefile also ensures required host directories exist before containers are started.

---

## Docker Compose Design

### Networking

* A dedicated Docker bridge network is used
* Containers communicate using Docker DNS and service names
* Internal services are not exposed to the host

This avoids using `network: host` and improves isolation.

---

### Data Persistence

Bind mounts are used to store persistent data on the host:

```text
/home/mohhusse/data/wordpress
/home/mohhusse/data/mariadb
```

Reasons for bind mounts:

* Required by the subject
* Data visible on host filesystem
* Survives container recreation

---

## Mandatory Services

### NGINX

* Acts as the only public entrypoint
* Exposes port 443 only
* Enforces TLSv1.2 and TLSv1.3
* Reverse proxies PHP requests to WordPress (PHP-FPM)

NGINX does not contain application logic.

---

### WordPress (PHP-FPM)

* Runs PHP-FPM only, without a web server
* Connects to MariaDB using Docker DNS
* Uses Redis for object caching
* Application files are stored in a bind-mounted directory

The administrator username does not contain the word "admin" as required.

---

### MariaDB

* Dedicated database container
* Initialized using environment variables
* No hardcoded credentials in Dockerfiles
* Data persisted using a bind mount

MariaDB is not exposed to the host network.

---

## Bonus Services

### Redis

* Used as a WordPress object cache
* Internal-only service
* Not exposed to the host
* Improves performance by reducing database queries

Redis is accessed using the service name `redis`.

---

### Adminer

* Lightweight database administration interface
* Runs in its own container
* Exposed on a separate port
* Used for inspection and debugging

Adminer does not replace the database or modify mandatory services.

---

### Static Website

* Served by a separate NGINX container
* Hosts a simple static page
* Runs independently from the main HTTPS entrypoint
* Demonstrates multi-service hosting

Using a separate container avoids impacting the mandatory NGINX configuration.

---

### FTP Server

* Uses vsftpd
* Runs in a dedicated container
* Uses passive mode for Docker compatibility
* Chrooted user for security
* Provides access only to WordPress files

FTP is used for controlled file management without container access.

---

### Monitoring

* Prometheus collects metrics
* Node Exporter exposes host system metrics
* Monitoring is read-only
* Does not interfere with application behavior

Prometheus is exposed for visualization, while Node Exporter remains internal.

---

## Design Decisions

### Why Separate Containers

Each service runs in its own container to:

* Improve isolation
* Simplify debugging
* Match real-world microservice design
* Comply with subject requirements

---

### Why TLS Only on Main Entry Point

* Required by the subject
* Reduces complexity
* Prevents misconfiguration
* Bonus services do not handle sensitive data

---

### Why Internal Services Are Not Exposed

Services such as MariaDB, Redis, and Node Exporter:

* Are only needed internally
* Do not require direct host access
* Would increase attack surface if exposed

---

## Bonus Justification Summary

| Service     | Justification                   |
| ----------- | ------------------------------- |
| Redis       | Performance optimization        |
| Adminer     | Database inspection             |
| Static site | Independent content hosting     |
| FTP         | Controlled file management      |
| Monitoring  | Observability and system health |

All bonus services are additive and do not affect mandatory services.

---

## Conclusion

This project demonstrates:

* Containerized infrastructure design
* Service isolation and networking
* Secure entrypoint configuration
* Data persistence strategies
* Practical DevOps concepts

The architecture prioritizes clarity, security, and maintainability while remaining fully compliant with the project requirements.