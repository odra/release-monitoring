FROM centos:7

#env vars
ENV DATA_DIR /opt/anitya/data
ENV ANITYA_WEB_CONFIG /opt/anitya/dev.toml
ENV DB_URL sqlite:///${DATA_DIR}/anitya-dev.sqlite
ENV ANITYA_HOME /opt/anitya
ENV ANITYA_APP_PORT 5000
ENV ANITYA_STATS_PORT 8000

#install required yum packages
RUN yum update -y && \
yum group install -y "Development Tools" && \
yum install -y postgresql-devel sqlite && \
yum install -y https://centos7.iuscommunity.org/ius-release.rpm && \
yum install -y python36u python36u-pip python36u-devel

#configure python and pip
RUN alternatives --install /usr/bin/pip pip /usr/bin/pip3.6 0 && \
alternatives --install /usr/bin/python python /usr/bin/python3.6 0 && \
pip install -U pip

RUN curl http://uwsgi.it/install | bash -s default /usr/bin/uwsgi
#groupadd -r uwsgi && useradd -r -g uwsgi uwsgi

RUN mkdir -p ${ANITYA_HOME} && \
mkdir -p ${DATA_DIR}

COPY . /opt/anitya

RUN pip install -U -r /opt/anitya/requirements.txt && \
chown -R 1001:0 ${ANITYA_HOME} && \
chown -R 1001:0 ${DATA_DIR} && \
chmod 775 -R /opt 

ENTRYPOINT ["/opt/anitya/scripts/entrypoint.sh"]

#USER 1001
