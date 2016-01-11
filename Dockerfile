FROM ubuntu:14.04
MAINTAINER Mitch Anderson <mitch@metauser.net>

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y python python-pip \
                       python-virtualenv gunicorn libpq-dev python-dev gcc wget && \
    wget https://github.com/Yelp/dumb-init/releases/download/v1.0.0/dumb-init_1.0.0_amd64.deb && \
    dpkg -i dumb-init_*.deb && \
    apt-get clean all


# Setup flask application
RUN mkdir -p /opt/yoked
COPY . /opt/yoked/
RUN pip install -r /opt/yoked/requirements/common.txt
WORKDIR /opt/yoked/api

EXPOSE 5000

# Start gunicorn
CMD ["/usr/bin/dumb-init", "/usr/bin/gunicorn", "-w", "2", "-b", ":3000", "api:app"]
