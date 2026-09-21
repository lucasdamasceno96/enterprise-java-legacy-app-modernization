# Enterprise Java Legacy Application Modernization

This repository tracks the modernization of a legacy Java application
([Spring PetClinic](https://github.com/spring-projects/spring-petclinic)) onto
Google Cloud.

The target architectural direction is:

> Spring PetClinic -> containerized Spring Boot application -> Cloud Run -> Cloud SQL PostgreSQL

This phase establishes a **reproducible local application baseline** only. It
does not introduce any cloud infrastructure.

## Repository layout

- The Spring PetClinic application source lives at the repository root
  (`pom.xml`, `mvnw`, `src/`, `docker-compose.yml`).
- `docs/architecture.md` — current-state architecture.
- `docs/adr/` — architecture decision records.
- `experiments/baseline/README.md` — how to build, test, and run the baseline
  locally against PostgreSQL.

## Quick start

Requirements: Java 17+, Docker.

```bash
# run the test suite
./mvnw test

# prepare local environment (git-ignored)
cp .env.example .env   # then set POSTGRES_PASSWORD in .env

# build the OCI image (Buildpacks, no Dockerfile)
./mvnw spring-boot:build-image

# start PostgreSQL and PetClinic as containers
docker compose up -d
```

The application is then available at <http://localhost:8080/>
(health: <http://localhost:8080/actuator/health>).

## Status

See `docs/adr/` for architecture decisions and `experiments/baseline/README.md`
for the current baseline details.
