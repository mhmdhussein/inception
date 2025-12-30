# USER DOCUMENTATION

## Overview

This document explains how to use and operate the Inception infrastructure from a user or administrator perspective.

The project provides a containerized web infrastructure running on a virtual machine, composed of multiple independent services managed with Docker Compose.

---

## Provided Services

### WordPress Website
- Main application
- Served securely over HTTPS
- Backed by a MariaDB database
- Uses Redis for caching

### Adminer
- Web-based database administration tool
- Allows inspection and management of the MariaDB database

### Static Website
- Simple static page served from a dedicated NGINX container
- Independent from WordPress

### FTP Server
- Provides file access to WordPress files
- Useful for uploading or managing content

### Monitoring
- Prometheus provides a web interface to observe system and container metrics
- Node Exporter collects host metrics internally

---

## Starting and Stopping the Project

### Start the infrastructure

From the root of the project:

```bash
make
````

This command builds all Docker images and starts the containers.

---

### Stop the infrastructure

To stop all running containers without deleting data:

```bash
make down
```

---

### Full cleanup (optional)

To remove containers, images, and stored data:

```bash
make fclean
```

⚠️ This will delete all persistent data.

---

## Accessing the Services

### WordPress

* URL:

  ```text
  https://mohhusse.42.fr
  ```

---

### Adminer

* URL:

  ```text
  http://localhost:8080
  ```
* Database server: `mariadb`

---

### Static Website

* URL:

  ```text
  http://localhost:8081
  ```

---

### FTP Server

* Host: `localhost`
* Port: `21`
* Mode: Passive
* Username: `ftpuser`
* Password: `ftppassword`
* Accessible directory: WordPress root files

---

### Monitoring (Prometheus)

* URL:

  ```text
  http://localhost:9090
  ```

Prometheus provides system and container metrics for monitoring purposes.

---

## Data Storage

All persistent data is stored on the host machine under:

```text
/home/$USER/data
```

### WordPress files

```text
/home/$USER/data/wordpress
```

### MariaDB database

```text
/home/$USER/data/mariadb
```

These directories remain intact across container restarts.

---

## Checking Service Status

To see running containers:

```bash
docker compose ps
```

To view logs for a specific service:

```bash
docker logs <service_name>
```

Example:

```bash
docker logs wordpress
```

---

## Notes

* NGINX is the only HTTPS entrypoint.
* Internal services (MariaDB, Redis, Node Exporter) are not exposed publicly.
* FTP and Adminer are bonus services and use separate ports.
* Monitoring is read-only and does not affect application behavior.

---

## Troubleshooting

If a service is not accessible:

1. Ensure containers are running using `docker compose ps`
2. Check logs using `docker logs`
3. Restart the stack if needed:

   ```bash
   make down
   make
   ```
