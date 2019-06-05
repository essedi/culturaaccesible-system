FROM ruby:2.4.2



RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list

RUN apt-get update
#RUN apt-get update

ENV SYSTEM_MODE development
ENV HOME=/opt/app/culturaaccesible-system

RUN mkdir -p $HOME
ADD . $HOME
WORKDIR $HOME
RUN gem install bundler -v 1.14.6
RUN bundle install
