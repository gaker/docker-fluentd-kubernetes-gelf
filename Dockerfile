FROM centos:7

MAINTAINER Greg Aker <greg@gregaker.net>

ENV LD_LIBRARY_PATH /opt/rh/rh-ruby23/root/usr/lib64
ENV GELF_HOST graylog.default.svc.cluster.local
ENV GELF_PORT 12900
ENV FLUENTD_VERSION 0.14.1

RUN yum update -y && \
    yum install -y centos-release-scl-rh && \
    yum install -y scl-utils make gcc gcc-c++ bzip2 rh-ruby23 rh-ruby23-ruby-devel && \
    scl enable rh-ruby23 'gem update --system --no-document' && \
    scl enable rh-ruby23 'gem install --no-document json_pure jemalloc' && \
    scl enable rh-ruby23 "gem install --no-document fluentd -v ${FLUENTD_VERSION}" && \
    scl enable rh-ruby23 "gem install --no-document  fluent-plugin-kubernetes_metadata_filter fluent-plugin-forest gelf" && \
    ln -s /opt/rh/rh-ruby23/root/usr/local/bin/* /usr/bin && \
    mkdir -p /etc/fluent/plugin && \
    curl https://raw.githubusercontent.com/tech-angels/fluent-plugin-gelf/master/lib/fluent/plugin/out_gelf.rb -o /etc/fluent/plugin/out_gelf.rb && \
    yum remove -y rh-ruby23-ruby-devel-2.3.0-60 glibc-devel-2.17-106.el7_2.8 libstdc++-devel-4.8.5-4.el7.x86_64  make gcc gcc-c++ bzip2 rh-ruby23-ruby-devel \
    yum clean all

ADD fluent.conf /etc/fluent/fluent.conf

CMD ["je", "fluentd"]

