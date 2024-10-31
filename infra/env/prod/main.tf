{
  "family": "blog-app",
  "networkMode": "bridge",
  "containerDefinitions": [
    {
      "name": "blog",
      "image": "blog:latest",
      "memory": 512,
      "cpu": 256,
      "essential": true,
      "portMappings": [
        {
          "containerPort": 5000,
          "hostPort": 5000
        }
      ],
      "environment": [
        {
          "name": "SECRET_KEY",
          "value": "my-secret-key"
        },
        {
          "name": "DATABASE_URL",
          "value": "mysql+pymysql://blog:password@dbserver/blog"
        }
      ],
      "links": [
        "mysql:dbserver"
      ]
    },
    {
      "name": "mysql",
      "image": "mysql/mysql-server:5.7",
      "memory": 512,
      "cpu": 256,
      "essential": true,
      "environment": [
        {
          "name": "MYSQL_RANDOM_ROOT_PASSWORD",
          "value": "yes"
        },
        {
          "name": "MYSQL_DATABASE",
          "value": "blog"
        },
        {
          "name": "MYSQL_USER",
          "value": "blog"
        },
        {
          "name": "MYSQL_PASSWORD",
          "value": "password"
        }
      ]
    }
  ]
}
