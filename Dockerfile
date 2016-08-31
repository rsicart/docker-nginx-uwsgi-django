FROM debian:jessie

ENV LANG en_US.UTF-8

RUN apt-get update && \
	apt-get install -y \
			curl \
			gettext \
			git \
			nginx \
			python3 \
			python3-dev \
			python3-pip \
			supervisor \
			vim

RUN pip3 install \
		PyMySQL \
		uwsgi \
		django \
		pytz

RUN mkdir /code
WORKDIR /code

ADD config/supervisor/ /etc/supervisor/conf.d/
ADD config/nginx/example-site.conf /etc/nginx/sites-available/example-site.conf
RUN cd /etc/nginx/sites-enabled && \
	ln -s ../sites-available/example-site.conf ./example-site.conf

RUN mkdir /etc/uwsgi
RUN mkdir /etc/uwsgi/vassals
ADD config/uwsgi/uwsgi.ini /etc/uwsgi/uwsgi.ini
ADD config/uwsgi/uwsgi_params /etc/uwsgi/uwsgi_params
RUN cd /etc/uwsgi/vassals && \
	ln -s ../uwsgi.ini ./uwsgi.ini

CMD ["/usr/bin/supervisord"]
