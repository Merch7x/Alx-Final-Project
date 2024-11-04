
# CI/CD FOR A FLASK APPLICATION

This projects bring together the principals of continuous integration(CI) and continuous delivery/deployment (CD) together by creating an end to end pipeline that deploys a containerized flask application to infrastructure Hosted on Aws.

It emphasizes, test, code-quality, and code-security in CI and Infrastucture As Code and Environments in CD.
## Authors

- [@merch7x](https://www.github.com/merch7x)

## Tech Stack

**Runtime:** Python 3.12

**Framework:** Flask

**Server:** Gunicorn Production Server

**Infrascture As Code:** Terraform

## Demo

https://drive.google.com/file/d/1mgBfkOc9SKMDj7py3gtmc9zOakPMEqa2/view?usp=sharing


## Installation

Install the Flask App using the in memory sqlite DB

```bash
  docker pull merch7x/flask-blog:latest
  docker run -d -p 5000:5000 flask-blog:latest
```
Using a different database

```bash
  docker run --name mysql -d -e MYSQL_RANDOM_ROOT_PASSWORD=yes -e  MYSQL_DATABASE=blog -e MYSQL_USER=blog -e MYSQL_PASSWORD=password mysql/mysql-servers:5.7
  ```
```bash
  docker run --name blog -d -p 5000:5000 -e SECRET_KEY=your_secret_key --link mysql:dbserver -e DATABASE_URL=mysql+pymysql://blog: password@dbserver/blog merch7x/flask-blog:latest
```