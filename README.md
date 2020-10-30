## DOCKER INSTALATION:

1.- You must install Docker following the web instructions:

Link: www.docker.com

2.- You must follow the steps in the docker web to be familiar with.

3.- Also follow the instructions 'Post-installation steps for Linux'.

4.- It's important to clean your docker images and containers when you are goin to start with docker.

5. Install docker-compose.

Link: https://docs.docker.com/compose/install/

6. If you are user Windows remember share your C: drive in docker settings.


## RUN APP

1.- Download git:

~~~
git clone https://github.com/devscola/culturaaccesible-system.git
~~~

Start the docker-compose service to be able to run the test:

~~~
docker-compose build
~~~

In one console, up the docker container:

**Console A:**

~~~
docker-compose up
~~~


If you want test the app, in other console run the tests:

**Console B:**

All test:
~~~
docker-compose exec system bundle exec rake test
~~~

If you want view app, open navigator (firefox, chrome, ...) and visit localhost:4567

## PRODUCTION ENVIRONMENT
Connnect trough ssh using CulturaAccesibleEssedi.pem private key

ssh -i "CulturaAccesibleEssedi.pem" ubuntu@ec2-54-198-129-130.compute-1.amazonaws.com

1) checkout repository
2) build composer image
3) run

~~~
nohup docker-composer up &
~~~
