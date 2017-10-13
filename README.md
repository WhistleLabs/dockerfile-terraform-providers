# Unif.io Terraform Provider Dockerfile
[![Circle CI](https://circleci.com/gh/WhistleLabs/dockerfile-terraform-provider.svg?style=svg)](https://circleci.com/gh/WhistleLabs/dockerfile-terraform-provider)

## What is terraform

Terraform provides a common configuration to launch infrastructure — from physical and virtual servers to email and DNS providers. Once launched, Terraform safely and efficiently changes infrastructure as the configuration is evolved.

Simple file based configuration gives you a single view of your entire infrastructure.


[http://www.terraform.io/](http://www.terraform.io/)

Beginning in 0.10.x, Terraform is no longer including providers with their binary.  These are delivered as separate binaries.  This container will pull down the defined provider binaries so that they can be included in other containers.  This does not have a functioning Terraform binary included.  This is meant to be a add-on container.

## Dockerfile

This Docker image is based on the official [alpine:3.5](https://hub.docker.com/_/alpine/) base image.

