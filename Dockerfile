# PyHive + Superset 当前在 Python3 下还不稳定
FROM python:2.7
# Configure environment
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PATH=$PATH:/home/superset/.bin \
    PYTHONPATH=/home/superset/.superset:$PYTHONPATH \
    SUPERSET_VERSION=0.19.0
RUN apt-get update
RUN apt-get install -y curl python-dev libmysqlclient-dev build-essential libsasl2-dev
RUN pip install --upgrade pip
RUN pip install superset mysqlclient ldap3 psycopg2 redis pythrifthiveapi pyhive flask-oauth flask_oauthlib flask-mail sqlalchemy-redshift
RUN adduser superset && \
    mkdir /home/superset/.superset && \
    touch /home/superset/.superset/superset.db && \
    chown -R superset:superset /home/superset
# Configure Filesysten
WORKDIR /home/superset
COPY superset .
RUN chmod -R 777 .
RUN cp superset_config.py .superset/
VOLUME /home/superset/.superset

# Deploy application
EXPOSE 8088 3306
HEALTHCHECK CMD ["curl", "-f", "http://localhost:8088/health"]
ENTRYPOINT ["superset"]
CMD ["runserver"]
USER superset
