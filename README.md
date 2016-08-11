# docker-nginx-uwsgi-django boilerplate

## Introduction

This repository contains a Dockerfile to create a container running nginx and uwsgi. They are ready to be configured to execute a django application.
As a **bonus**, using maestro-ng, you can get a mariadb containers (using a data-only container pattern) too, to be used by Django.

## Getting started

First of all you need to build the images manually with docker because I didn't publish that on Dockerhub. In order to do that, execute:
```
docker build --tag=django_application_code --file ./Dockerfile.django_application_code
```
```
docker build --tag=nginx_uwsgi_django .
```

Launch data volume container from host application code folder:
```
docker run --detach -v "$PWD":/code --name django_code_1 django_application_code
```
Launch container from wherever you want:
```
docker run --detach -p 1080:80 --volumes-from django_code_1 --name nginx_uwsgi_django_1 nginx_uwsgi_django
```

Create a Django project and application in `/code`, with:
```
django-admin startproject helloproject
```
```
mkdir helloapp helloproject/helloproject
```
```
django-admin startapp helloapp helloproject/helloproject/helloapp
```

After that, edit nginx and uwsgi configuration files to match Django paths:

```
sed -i.bak -e 's/\/code\/app\/static;/\/code\/helloproject\/helloproject\/helloapp\/static;/' /etc/nginx/sites-available/example-site.conf
```
```
sed -i.bak -e 's/module = project.wsgi/module = helloproject.wsgi/' /etc/uwsgi/uwsgi.ini
```
Restart services to use the new configuration:
```
supervisorctl restart all
```
## Maestro
You can use maestro to get up and running the containers (but you still need to follow steps in *Getting started* section).

And launch all containers with:
```
maestro -f maestro.yml start
```
**Important**: do not forget to change root password in mysql, by default is `root`.

