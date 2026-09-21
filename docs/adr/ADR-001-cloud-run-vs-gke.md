# ADR-001: Cloud Run vs. GKE for Application Hosting

- **Status:** Proposed
- **Date:** 2026-09-04

## Context

The application being modernized is the Spring PetClinic sample application: a
single, HTTP-based Spring Boot monolith. The modernization effort must preserve
the existing business functionality and reuse the current Spring Boot
architecture.

A decision is needed on where the containerized application will ultimately run
on Google Cloud. The two main candidates under consideration are Cloud Run and
Google Kubernetes Engine (GKE).

## Decision

Cloud Run has been selected as the initial target runtime for the containerized
application.

## Rationale

- The application is an HTTP-based Spring Boot monolith that can be packaged as
  a single container image.
- The application's business logic should remain unchanged, which favors a
  runtime that accepts a standard container without requiring re-architecture.
- The current workload does not justify the operational complexity of running
  and maintaining a Kubernetes cluster.
- Cloud Run provides a managed container runtime, reducing operational overhead
  (no cluster management, autoscaling, and scaling to zero).
- GKE remains a valid alternative for workloads that eventually require
  Kubernetes-level control (e.g., custom networking, multi-container pods, or
  specific scheduling requirements).

## Consequences

- The application will be packaged as a container image.
- Operational complexity is minimized during early phases.
- The decision is provisional and must be validated through later experiments.
  If future requirements demand Kubernetes-level control, GKE can be revisited.

## Validation

This decision will be validated through later experiments (for example,
deploying the containerized application to Cloud Run and evaluating whether it
meets functional and operational requirements).
