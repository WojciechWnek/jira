ifeq ($(PROD),true)
	DOCKER_COMPOSE = docker-compose -f docker-compose.production.yml
else
	DOCKER_COMPOSE = docker compose -f docker-compose.local.yml
endif

DOCKER_RUN = $(DOCKER_COMPOSE) run --rm django
RUN_MANAGE_PY = $(DOCKER_RUN) python manage.py

up:
	$(DOCKER_COMPOSE) up --force-recreate $(service)

build:
	$(DOCKER_COMPOSE) build

down:
	$(DOCKER_COMPOSE) down

down-v:
	$(DOCKER_COMPOSE) down -v

migrate:
	$(RUN_MANAGE_PY) migrate $(app) $(num)

makemigrations:
	$(RUN_MANAGE_PY) makemigrations $(service)

createsuperuser:
	$(RUN_MANAGE_PY) createsuperuser

startapp:
	$(DOCKER_RUN) bash -c "cd jira_api/ && python ../manage.py startapp $(app)"

shell:
	$(DOCKER_COMPOSE) exec -it $(service) bash

logs:
	$(DOCKER_COMPOSE) logs $(service) -f

mypy:
	$(DOCKER_RUN) mypy .

test:
	$(DOCKER_RUN) pytest $(path)

run_coverage:
	$(DOCKER_RUN) bash -c "coverage run -m pytest && coverage report -m"

chown:
	sudo chown -R $(USER):$(USER) .
