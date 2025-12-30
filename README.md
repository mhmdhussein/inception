*This project has been created as part of the 42 curriculum by mohhusse.*

# Inception

## Description

Inception is a system administration project focused on designing and deploying a complete containerized infrastructure using Docker and Docker Compose.

The goal is to understand how multiple services can be isolated, networked, secured, and persisted inside containers while running on a virtual machine.  
All services are built from custom Docker images and orchestrated using Docker Compose.

The infrastructure includes a secure HTTPS entrypoint, a WordPress application backed by a database, and several bonus services demonstrating real-world DevOps concepts such as caching, administration, file transfer, static hosting, and monitoring.

---

## Architecture Overview

The project is composed of the following services:

- NGINX  
  Acts as the only HTTPS entrypoint (TLSv1.2 and TLSv1.3) and reverse proxies requests to WordPress.

- WordPress (PHP-FPM)  
  Handles application logic and content management, without embedding a web server.

- MariaDB  
  Stores WordPress data and runs as an isolated database service.

- Redis (bonus)  
  Provides object caching to improve WordPress performance.

- Adminer (bonus)  
  Lightweight database administration interface.

- Static Website (bonus)  
  A simple static page served from a separate NGINX container.

- FTP Server (bonus)  
  Allows controlled file access to WordPress data using passive FTP.

- Monitoring Stack (bonus)  
  Prometheus and Node Exporter provide read-only system and container metrics.

All services communicate through a dedicated Docker bridge network.

---

## Instructions

### Prerequisites

- Linux virtual machine
- Docker
- Docker Compose (v2)
- Make

### Build and Run

To build and start the infrastructure:

```bash
make
````

To stop the infrastructure without losing data:

```bash
make down
```

To completely remove containers, images, and data:

```bash
make fclean
```

---

## Data Persistence

Persistent data is stored on the host machine using bind mounts:

```text
/home/mohhusse/data/wordpress
/home/mohhusse/data/mariadb
```

These directories survive container restarts and rebuilds.

---

## Docker Concepts Explained

### Virtual Machines vs Docker

* Virtual machines emulate an entire operating system.
* Docker containers share the host kernel and isolate applications at the process level.

Docker provides faster startup times, lower resource usage, and easier service composition.

---

### Secrets vs Environment Variables

* Environment variables are used for configuration values.
* Sensitive data should be stored using Docker secrets in real production environments.

For this educational project, environment variables are sufficient and explicitly required by the subject.

---

### Docker Network vs Host Network

* Containers communicate using a custom Docker bridge network.
* This avoids exposing internal services directly to the host network.

Using Docker networking improves isolation and security.

---

### Docker Volumes vs Bind Mounts

* Bind mounts are used to ensure data is visible and accessible from the host.
* This matches the project requirement that data must exist under `/home/login/data`.

---

## Bonus Features

* Redis
  Improves performance by caching WordPress objects and reducing database load.

* Adminer
  Provides a simple and secure way to inspect and manage the database.

* Static Website
  Demonstrates hosting an additional independent service without impacting the main infrastructure.

* FTP Server
  Allows controlled file management of WordPress content using a dedicated service.

* Monitoring
  Prometheus and Node Exporter provide observability into system health without affecting application behavior.

Each bonus service runs in its own container and does not interfere with mandatory services.

---

## Resources

* Docker documentation
  [https://docs.docker.com](https://docs.docker.com)

* Docker Compose documentation
  [https://docs.docker.com/compose](https://docs.docker.com/compose)

* NGINX documentation
  [https://nginx.org/en/docs](https://nginx.org/en/docs)

* WordPress documentation
  [https://wordpress.org/documentation](https://wordpress.org/documentation)

* MariaDB documentation
  [https://mariadb.org/documentation](https://mariadb.org/documentation)

* Redis documentation
  [https://redis.io/docs](https://redis.io/docs)

* Prometheus documentation
  [https://prometheus.io/docs](https://prometheus.io/docs)

### AI Usage

AI tools were used to assist with:

* Architecture planning
* Configuration validation
* Debugging explanations
* Documentation structuring

Any generated content was reviewed, understood, and adapted manually.

---

## Notes

* NGINX is the only HTTPS entrypoint.
* Internal services are not publicly exposed.
* The administrator username does not contain the word "admin" as required.
* All Docker images are built locally without using prebuilt service images.
