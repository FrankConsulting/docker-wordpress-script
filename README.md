# New Web Project

This script creates a Wordpress Docker instance on your local machine, clones the [tws_theme](https://github.com/TheWebsiteSpace/tws_theme) repository, and sets up the project.

## Requirements

- [Docker](https://www.docker.com/)
- [Node.js](https://nodejs.org/en/) (For **Mac** recommended install is via Homebrew, for **Linux** recommended install is via the CLI)

## Guide

Simply call this script from the CLI to run the script.
Once run all you need to do is enter the project name (no spaces) and wait until it has completed.
*Make sure you have cloned [tws_theme](https://github.com/TheWebsiteSpace/tws_theme) and made the project following the same convetion you used when inputting you name.*

## Setup

This script calls and writes files on your local directory and will need to be tweaked for each machine.

You will need to edit the following variables:

- `PATH_PROJECT` - The location of your local workspace
- `PATH_SCRIPT` - The localtion of this script

## Exporting DB From MySQL

**Make sure the container is running!**

### PHPMyAdmin

1. Open [localhost:8080](http://localhost:8080/) to connect to PHPMyAdmin.
1. Click on the database
1. Click "Export" tab
1. Select "Quick" export
1. Press "Go"
1. Save

### Docker Pipe

Alternatively you can run the following command to pipe the database into an sql file to export.

```
docker exec CONTAINER_NAME /usr/bin/mysqldump -uroot -proot DATABASE_NAME > ~/Desktop/PROJECT_NAME.sql
```

You can use the following commands to access the MySQL shell in docker.

1. `docker exec -it CONTAINER_NAME bash`
1. `mysql -uroot -proot`

Once inside you can use all your regular MySQL commands such as `SHOW DATABASES;`.

Use the following key to find the variables listed in the above command.

## Importing Database into MySQL

Using the following command you can import an sql file into a MySQL database hosted on Docker.

```bash
cat backup.sql | docker exec -i CONTAINER_NAME mysql -uuser -ppassword DATABASE_NAME
```

## Key

The following sub-sections briefly explain how to find unique information that will be different for every project.

### `CONTAINER_NAME`

1. Open Docker App
1. Click arrow to dropdown all grouped containers
1. `CONTAINER_NAME` = the MySQL container name

### `DATABASE_NAME`

*While docker container is running*

1. `docker exec -it CONTAINER_NAME mysql -uroot -proot`
1. `SHOW DATABASES;`
1. `exit`

`DATABASE_NAME` = the database shown from `SHOW DATABASES;`.

### `PROJECT_NAME`

The name of the project, i.e. the name of your project GitHub repository.

