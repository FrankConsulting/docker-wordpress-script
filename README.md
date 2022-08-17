# Create Docker WordPress Environment

This script creates a Wordpress Docker instance on your local machine, clones your WordPress theme repository, and sets up the project.

---
**Note**

This script has only been tested on MacOS.
Use on Linux at your own expense, though likely no issue with minor changes.

Unsupported on Windows.

---

## Requirements

- [Docker](https://www.docker.com/)
- [Node.js](https://nodejs.org/en/) (For **Mac** recommended install is via Homebrew, for **Linux** recommended install is via the CLI)

## Recommended Changes

There are a few changes you have to make before running the commands.
However, all these changes are simple variable manipulations.
See the following table for instructions.

| Line | Change | Description |
| ---- | ------ | ----------- |
| 14 | `GIT_REPO_BASE` | The repo base the projected is located on |
| 15 | `PATH_SCRIPT` | The location of this script |
| 16 | `PATH_PROJECT` | The location of your local workspace |

## Guide

Simply call this script from the CLI to run the script.
Once run all you need to do is enter the project name (no spaces) and wait until it has completed.

---
**Note**

Make sure you have have already prepared your WordPress theme repository on GitHub.

---

## Accessing the Docker MySQL Database

**Make sure the container is running!**

### PHPMyAdmin [BROKEN]

1. Open [localhost:8080](http://localhost:8080/) to connect to PHPMyAdmin.
1. Enter login credentials

### MySQL Shell

You can use the following commands to access the MySQL shell.

1. `docker exec -it CONTAINER_NAME bash`
1. `mysql -uroot -proot`

Once inside you can use all your regular MySQL commands such as `SHOW DATABASES/TABLES;`, `SELECT * FROM table;`, etc.

### Exporting Database

You can run the following command to pipe the database into an `.sql` export.

```bash
docker exec CONTAINER_NAME /usr/bin/mysqldump -uroot -proot DATABASE_NAME > ~/Desktop/PROJECT_NAME.sql
```

### Importing Database into MySQL

Using the following command you can import an `.sql` file into a MySQL database hosted on Docker.

```bash
cat backup.sql | docker exec -i CONTAINER_NAME mysql -uuser -ppassword DATABASE_NAME
```

## Key

The following sub-sections briefly explain how to find the unique information that will be different for every project.

### `CONTAINER_NAME`

*While docker container is running*

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

