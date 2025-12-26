NAME = inception

COMPOSE = docker compose
COMPOSE_FILE = srcs/docker-compose.yml
ENV_FILE = srcs/.env

USER = mohhusse
DATA_DIR = /home/$(USER)/data
WP_DATA = $(DATA_DIR)/wordpress
DB_DATA = $(DATA_DIR)/mariadb

all: up

# Create required directories and start containers
up:
	@mkdir -p $(WP_DATA)
	@mkdir -p $(DB_DATA)
	$(COMPOSE) --env-file $(ENV_FILE) -f $(COMPOSE_FILE) up -d --build

# Stop containers
down:
	$(COMPOSE) -f $(COMPOSE_FILE) down

# Stop containers and remove volumes
clean:
	$(COMPOSE) -f $(COMPOSE_FILE) down -v

# Full cleanup (containers, images, volumes, data)
fclean: clean
	@docker system prune -af
	@sudo rm -rf $(DATA_DIR)

# Restart stack
re: down up

# Show running containers
ps:
	$(COMPOSE) -f $(COMPOSE_FILE) ps

.PHONY: all up down clean fclean re ps
